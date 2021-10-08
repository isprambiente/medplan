class ActionView::Helpers::FormBuilder
  def error_message_for(field_name)
    if self.object.errors[field_name].present?
      model_name              = self.object.class.name.downcase
      id_of_element           = "error_#{model_name}_#{field_name}"
      class_name              = 'help has-text-danger pl-3'

      tag.span(self.object.errors[field_name].join(', '), id: id_of_element, class: class_name)
    end
  rescue
    nil
  end
end