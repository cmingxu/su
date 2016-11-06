module Action
  class Base
    attr_accessor :action, :params, :ctx, :dialog

    def initialize ctx, dialog, params
      self.ctx = ctx
      self.dialog = dialog
      self.params = params
    end

    alias :context :ctx
  end
end
