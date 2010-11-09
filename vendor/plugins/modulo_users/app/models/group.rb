class Group < ActiveRecord::Base

  has_and_belongs_to_many :users, :order => "login ASC"
  
  validates :name, :presence => true, :uniqueness => true
  
  has_friendly_id :name, :use_slug => true, :approximate_ascii => true

  # Devuelve cierto si el usuario user pertenece al grupo
  def user_pertenece_al_grupo?(user)
    return self.users.include?(user)
  end

  # Devuelve los usuarios del grupo
  def users_del_grupo
    return self.users.select("id, login, system")
  end

  # Devuelve true si puedo eliminar al usuario del grupo
  def can_delete_user?(user)
    return false if self.system? and user.system?
    return true
  end

  # Añadir usuario al grupo
  def add_to_group(user)
    self.users << user
  end

  # Elimina al usuario del grupo si el usuario es del sistema y el grupo también
  def delete_from_group(user)
    self.users.delete(user) if can_delete_user?(user)
  end

  # Invitacion a usuario del grupo seleccionado
  def invite_user(user)
    
  end

  # 

end