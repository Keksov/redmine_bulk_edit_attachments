module RedmineBulkEditAttachmnets
  module IssuesControllerPatch
    def self.included(base)
      base.class_eval do
        # Add a new method to handle file attachments during bulk update
        def bulk_update_with_attachments
          # @issues = Issue.where(:id => params[:ids])
          # puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAA 1"
          find_issues
          unless params[:attachments].present?
            # puts 'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB 0'
            bulk_update_without_attachments
            return
          end

          attachments = []
          params[:attachments].each do |_index, file|
            # puts 'AAAAAAAAAAAAAAAAAAAAAAAAAAAA 3' + file.inspect
            token = file[:token].to_s
            # puts 'AAAAAAAAAAAAAAAAAAAAAAAAAAAA 4' + token.inspect
            next if token.blank?

            attachment_id = token.split('.')[0]
            attachment = Attachment.find_by_id(attachment_id)
            attachments << attachment
          end

          # puts 'AAAAAAAAAAAAAAAAAAAAAAAAAAAA 5' + attachments.inspect

          @issues.each do |issue|
            attachments.each do |attachment|
              new_attachment = attachment.dup
              new_attachment.author = User.current
              new_attachment.container = issue
              new_attachment.save!
              issue.attachments << new_attachment
            end
          end

          # drop orphane attachments which ids are in attachments array
          Attachment.where(id: attachments.map(&:id)).delete_all

          bulk_update_without_attachments
        end

        # Use alias_method_chain to add our new functionality
        alias_method :bulk_update_without_attachments, :bulk_update
        alias_method :bulk_update, :bulk_update_with_attachments
      end
    end
  end
end

unless IssuesController.included_modules.include?(RedmineBulkEditAttachmnets::IssuesControllerPatch)
  IssuesController.include RedmineBulkEditAttachmnets::IssuesControllerPatch
end
