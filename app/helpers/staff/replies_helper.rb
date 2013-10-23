module Staff::RepliesHelper
  def format_reply(reply)
    result =  "%s: %s" % [reply.author, reply.response]
    result << " * Reassigned to #{reply.new_assignee}"     if reply.new_assignee.present?
    result << " * Status changed to #{t reply.new_status}" if reply.new_status.present?
    result
  end
end
