class Upload < ActiveRecord::Base

  attr_accessor :data

  validates_presence_of :uuid

  after_save :save_to_disk
  def initialize(*args)
    super
    self.uuid ||= UUID.generate(:compact)
  end

  def path
    File.join(Rails.root, "public", "uploads", uuid)
  end

  def save_to_disk
    File.open(path, "wb") do |f|
      f.write(self.data.read)
    end
  end

end
