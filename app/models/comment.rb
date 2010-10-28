class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  default_scope :order => 'created_at ASC'

  validates :comment, :presence => true
  validates :author, :presence => true
  validates :email, :presence => true

  # Antes de la validacion le relleno los datos del usuario
  before_validation :fill_user

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user

  private

    # Como cada comentario va a estar hecho por usuarios registrados vamos a guardar los datos mas importantes
    # del usuario en la misma tabla de comentarios como son autor, email
    # Proximamente puede que la ruta de la imagen thumb del usuario
    def fill_user
      @user = User.find(self.user_id, :select => "login, email")

      # Controlo si hay usuario o no, si no hay usuario va n a hacer que falle la validación de datos
      unless @user.blank?
        self.author = @user.login
        self.email = @user.email
      end
    end
end