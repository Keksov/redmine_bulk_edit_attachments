
Rails.configuration.to_prepare do

    # hooks
    require 'redmine_bulk_edit_attachments/hooks/views_issues_hook'

    # patches
    require 'redmine_bulk_edit_attachments/patches/issues_controller_patch'
end  