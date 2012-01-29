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
    assert ActiveModel::Validators::PresenceValidator.is_attached?(class_name, attribute)
  end

  def assert_presence_of_many_attributes(class_name, attributes_array)
    attributes_array.each do |attribute_name|
      assert_presence_of_attribute(class_name, attribute_name)
    end
  end

end
