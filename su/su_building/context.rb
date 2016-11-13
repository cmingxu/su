Sketchup::require File.join(File.dirname(__FILE__), 'helper')

class String
  def camelize
    self.split('_').map {|w| w.capitalize}.join
  end
end


class Context
  include Helper

  attr_accessor :logger, :dialog
  attr_accessor :current_user

  def persist_session
    save_data(current_user.to_json, "user_session")
  end

  def remove_session
    remove_data "user_session"
  end

  def load_session
    self.current_user = User.from_json(retrive_data("user_session"))
  end

  def update_js_value(dialog, id, new_val)
    js_command = "var dom = document.getElementById('data_transfer_channel'); var scope = angular.element(dom).scope(); scope.$apply(function() { scope.#{id} = JSON.parse('#{new_val}');});"
    logger.debug js_command
    dialog.execute_script(js_command)
  end

  def update_resolve(dialog, id, new_val)
    js_command = "var dom = document.getElementById('#{id}'); var scope = angular.element(dom).scope(); scope.$apply(function() { scope.resolve('#{new_val}');});"
    logger.debug js_command
    dialog.execute_script(js_command)
  end

  def call_js_function(dialog, id, fun, data)
    js_command = "var dom = document.getElementById('#{id}'); var scope = angular.element(dom).scope(); scope.$apply(function() { scope.#{fun}('#{data}');});"
    logger.debug js_command
    dialog.execute_script(js_command)
  end

  def update_reject(dialog, id, new_val)
    js_command = "var dom = document.getElementById('#{id}'); var scope = angular.element(dom).scope(); scope.$apply(function() { scope.reject('#{new_val}');});"
    logger.debug js_command
    dialog.execute_script(js_command)
  end

  def add_action_callback
    $ACTIONS.each do |action|
      dialog.add_action_callback action do |dialog, params|
        begin
          logger.debug params
          Object.const_get(action.camelize).send(:new, self, dialog, params).invoke
        rescue Exception =>   e
          logger.error e
        end
      end
    end
  end
end
