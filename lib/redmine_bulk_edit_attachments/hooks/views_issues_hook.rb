module RedmineBulkEditAttachmnets
  module Hooks
    class ViewsIssuesHook < Redmine::Hook::ViewListener
      render_on :view_issues_bulk_edit_details_bottom, partial: 'issues/bulk_edit'
    end
  end
end

