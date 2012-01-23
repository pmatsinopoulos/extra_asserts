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

end
