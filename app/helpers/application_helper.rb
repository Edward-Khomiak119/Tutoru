module ApplicationHelper
  def red_if_request_finished(state)
    return "red" if state == 'finished'
    ''
  end
end
