require 'active_support/concern'
require 'active_record'

module IsParanoid
  extend ActiveSupport::Concern

  module ClassMethods
    # Call this in your model to enable all the safety-net goodness
    #
    #  Example:
    #
    #  class Android < ActiveRecord::Base
    #    is_paranoid
    #  end
    def is_paranoid
      class_eval do
        # This is the real magic.  All calls made to this model will
        # append the conditions deleted_at => nil.  Exceptions require
        # using with_destroyed_scope (see self.delete_all,
        # self.count_with_destroyed, and self.find_with_destroyed )
        default_scope where(:deleted_at => nil)




        class << self
          def destroyed
            unscoped.where('deleted_at IS NOT NULL')
          end

          # Actually delete the model, bypassing the safety net.  Because
          # this method is called internally by Model.delete(id) and on the
          # delete method in each instance, we don't need to specify those
          # methods separately
          def delete_all conditions = nil
            with_exclusive_scope { super conditions }
          end

          # Return a count that includes the soft-deleted models.
          def count_with_destroyed
            unscoped.count
          end

          # Perform a count only on destroyed instances.
          def count_only_destroyed
            destroyed.count
          end

          # Return instances of all models matching the query regardless
          # of whether or not they have been soft-deleted.
          def find_with_destroyed *args
            unscoped.find(*args)
          end

          # Returns true if the requested record exists, even if it has
          # been soft-deleted.
          def exists_with_destroyed? *args
            unscoped.exists?(*args)
          end

          # Returns true if the requested record has been soft-deleted.
          def exists_only_destroyed? *args
            destroyed.exists?(*args)
          end
        end







        # Override the default destroy to allow us to flag deleted_at.
        # This preserves the before_destroy and after_destroy callbacks.
        # Because this is also called internally by Model.destroy_all and
        # the Model.destroy(id), we don't need to specify those methods
        # separately.
        def destroy
          _run_destroy_callbacks do
            destroy_without_callbacks
          end
        end


        # Set deleted_at flag on a model to nil, effectively undoing the
        # soft-deletion.
        def restore
          self.deleted_at_will_change!
          self.deleted_at = nil
          save :callbacks => false, :validate => false
        end

        # Has this model been soft-deleted?
        def destroyed?
          !deleted_at.nil?
        end
        
        protected

          # Mark the model deleted_at as now.
          def destroy_without_callbacks
            self.deleted_at = current_time_from_proper_timezone
            save :callbacks => false, :validate => false
          end
      end
    end
  end
end

ActiveSupport.on_load(:active_record) { include IsParanoid }
