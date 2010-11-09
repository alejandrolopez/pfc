require 'digest/sha1'

class User < ActiveRecord::Base

  has_many :comments
  
  has_friendly_id :login, :use_slug => true, :approximate_ascii => true
  acts_as_commentable

  # Relacion con grupos
  has_and_belongs_to_many :groups

  # Atributo virtual para password
  attr_accessor :password, :password_confirmation

  # Validación de datos
  validates :login, :presence => true, :uniqueness => true, :length => {:minimum => 5}
  validates :email, :presence => true, :uniqueness => true, :format => {:with => /^(\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,4})+)?$/}
  validates :password, :presence => true, :confirmation => true, :length => {:minimum => 5}, :if => (:password_required? and lambda{|x| !x.password.blank?})

  before_save :encrypt_password
  before_create :make_activation_code 

  # Devuelve los apellidos
  def surname
    return self.surname1.to_s + " " + self.surname2.to_s
  end
  
  # Devuelve el nombre y apellidos
  def complete_name
    return self.name.to_s + " " + self.surname1.to_s + " " + self.surname2.to_s
  end

  # Saber si un usuario pertenece a un grupo en particular
  def pertenece_al_grupo?(group)
    return self.groups.include?(group)
  end
  
  # Activación del usuario en la base de datos
	def activate
		@activated = true
		self.activated_at = Time.now.utc
		self.activation_code = nil
		save(:validate => false)
	end

  # Se comprueba si el usuario está activo
  def active?
		!activated_at.nil?
	end

	# Comprobación para ver si el usuario está autentificado en el sistema
  def self.authenticate(login, password)
		u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login], :select => "id, crypted_password, salt"
		u && u.authenticated?(password) ? u : nil
	end

  # Comprobación para ver si el usuario está autentificado en el sistema y en el site
  def self.authenticate_by_site(login, password, site)
		u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL and site_id = ?', login, site]
		u && u.authenticated?(password) ? u : nil
	end

	# Encriptación del salt generado y de la password
  def self.encrypt(password, salt)
		Digest::SHA1.hexdigest("--#{salt}--#{password}--")
	end

	# Encripta el password con la salt
  def encrypt(password)
		self.class.encrypt(password, salt)
	end

  # Para ver si la contraseña enviada se corresponde con la contraseña encriptada en el sistema
  def authenticated?(password)
		crypted_password == encrypt(password)
	end
  
  # Generacion de contraseña aleatoria
  def generar_remember_token
    self.remember_token = Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join)
    
    # Dejamos que se modifique la contraseña durante al menos un día
    self.remember_token_expires_at = (Time.now + 1.day)
    self.save(false)
  end


  protected

    # Encriptación de la password, se genera el salt con la hora actual y el login del usuario
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end

    def password_required?
      crypted_password.blank? || !password.blank?
    end

    # Se realiza el código de activación que se envia por correo electrónico
    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join)
    end
end