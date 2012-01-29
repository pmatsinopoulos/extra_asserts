require 'validator_attachment'

class ActiveSupport::TestCase

  # Asserts that an attribute cannot be null in db.
  def assert_not_null_in_db(class_name, some_valid_attributes, attribute)
    instance = class_name.new
    some_valid_attributes.each do |attribute_name, attribute_value|
      instance.send("#{attribute_name}=", attribute_value)
    end

    instance.send("#{attribute}=", nil)
    assert_raises ActiveRecord::StatementInvalid, "You expected an exception of StatementInvalid when saving attribute: #{attribute}" do
      instance.save!(:validate => false)
    end
  end

  def assert_many_not_null_in_db(class_name, some_valid_attributes, attributes_array)
    attributes_array.each do |attribute_name|
      assert_not_null_in_db(class_name, some_valid_attributes, attribute_name)
    end
  end

  # It checks that the attribute +attribute+ of the model +class_name+
  # is limited in storage by the value +length+
  def assert_length_in_db(class_name, some_valid_attributes, attribute, length, destroy=false)
    instance = class_name.new
    some_valid_attributes.each do |attribute_name, attribute_value|
      instance.send("#{attribute_name}=", attribute_value)
    end

    instance.send("#{attribute}=", "a" * (length + 1))
    assert_raises ActiveRecord::StatementInvalid, "<#{class_name}>.<#{attribute}> with length #{length} seems to be ok" do
      instance.save!(:validate => false)
    end

    instance.send("#{attribute}=", "a" * length)
    assert instance.save(:validate => false)

    instance.destroy if destroy
  end

  def assert_many_lengths_in_db(class_name, some_valid_attributes, attributes_lengths_hash)

    attributes_lengths_hash.each do |attribute_name, length|
      assert_length_in_db(class_name, some_valid_attributes, attribute_name, length, true)
    end

  end

  # Model-level related attributes

  def assert_presence_of_attribute(class_name, attribute)
    assert ActiveModel::Validations::PresenceValidator.is_attached?(class_name, attribute.to_sym)
  end

  def assert_presence_of_many_attributes(class_name, attributes_array)
    attributes_array.each do |attribute_name|
      assert_presence_of_attribute(class_name, attribute_name)
    end
  end

  # It checks that the attribute +attribute+ of the model +class_name+
  # is limited in length by the value +length+
  def assert_length_in_model(class_name, attribute, length)
    assert ActiveModel::Validations::LengthValidator.is_attached?(class_name, attribute.to_sym, {:maximum => length})
  end

  def assert_many_lengths_in_model(class_name, attributes_lengths_hash)
    attributes_lengths_hash.each do |attribute_name, length|
      assert_length_in_model(class_name, attribute_name, length)
    end
  end

  def assert_boolean_in_model(class_name, attribute)
    assert ActiveModel::Validations::InclusionValidator.is_attached?(class_name, attribute.to_sym, {:in => [true, false]})
  end

  def assert_many_boolean_in_model(class_name, attributes)
    attributes.each do |attribute|
      assert_boolean_in_model(class_name, attribute)
    end
  end

  # Asserts that an instance is invalid, and optionally on a specific attribute with specific number of errors
  #
  # Example calls:
  #   assert_invalid MyProduct
  #   assert_invalid MyProduct, {:name => 1}
  #
  def assert_invalid(instance, errors_on)
    assert !instance.valid?, "#{instance} expected to be invalid but it was valid"
    errors_on.each do |k,v|
      assert_equal v, instance.errors[k].size, "you expected #{v} errors on #{k} but there were #{instance.errors[k].size}"
    end unless errors_on.nil?
  end

  # Asserts that a model has a valid attribute. The model itself may be invalid, but
  # the method checks the errors only on the particular attribute
  #
  def assert_valid_attribute(instance, attribute)
    instance.valid?
    assert_equal 0, instance.errors[attribute.to_sym].size
  end

end
