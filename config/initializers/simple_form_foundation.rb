# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.wrappers :foundation, class: :input, hint_class: :field_with_hint, error_class: :error do |b|
    #b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.wrapper :label_input, class: 'row' do |ba|
      ba.use :label, wrap_with: { class: 'large-3 columns' }
      ba.use :input, wrap_with: { class: 'large-6 columns left' }
      ba.use :hint,  wrap_with: { class: 'large-3 columns' }
      ba.wrapper class: 'large-3 columns' do |bba|
        bba.use :error, wrap_with: { tag: 'small', class: 'error' }
      end
    end

    # Uncomment the following line to enable hints. The line is commented out by default since Foundation
    # does't provide styles for hints. You will need to provide your own CSS styles for hints.
  end

  # CSS class for buttons
  config.button_class = 'button'

  config.label_class = 'right'

  # CSS class to add for error notification helper.
  config.error_notification_class = 'alert-box alert'

  # The default wrapper to be used by the FormBuilder.
  config.default_wrapper = :foundation
end

SimpleForm.browser_validations = false
