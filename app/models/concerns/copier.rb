module Copier
  extend ActiveSupport::Concern

  included do
  end

  def do_copy &block
    wrap_copy do
      block.call if block
    end
  end

  def wrap_copy &block
    new_item = nil; message = "Empty Message #{self.class.name}"
    self.class.transaction do
      @copied_item = self.class.new
      @copied_item.attributes = self.attributes

      block.call if block

      if @copied_item.save
      else
        message = @copied_item.errors.full_messages
        raise ActiveRecord::Rollback
      end
    end

    [@copied_item, message]
  end

end
