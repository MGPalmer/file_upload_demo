class Upload < ActiveRecord::Base

  attr_accessor :data

  validates_presence_of :uuid
  validates_presence_of :data, :message => "Please choose a file to upload."

  before_save :save_original_filename
  after_save :save_to_disk

  def initialize(*args)
    super
    self.uuid ||= UUID.generate(:compact)
  end

  def path
    File.join(Rails.root, "public", "uploads", uuid)
  end

  def size
    File.size?(path)
  end

  def save_to_disk
    File.open(path, "wb") do |f|
      f.write(self.data.read)
    end
  end

  def save_original_filename
    self.original_filename ||= self.data.original_filename
  end

end
