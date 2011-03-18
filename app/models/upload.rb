class Upload < ActiveRecord::Base

  attr_accessor :data, :file

  validates_presence_of :uuid
  validates_presence_of :data, :message => "Please choose a file to upload."

  before_save :save_original_filename
  after_create :save_to_disk
  after_destroy :delete_file

  def initialize(*args)
    super
    self.uuid ||= UUID.generate(:compact)
    self.data ||= self.file.read if self.file
  end

  def path
    File.join(Rails.root, "public", "uploads", uuid)
  end

  def title
    t = self[:title]
    t.blank? ? "no title given" : t
  end

  def size
    File.size?(path)
  end

  def save_to_disk
    File.open(path, "wb") do |f|
      f.write(data)
    end
  end

  def save_original_filename
    self.original_filename ||= self.file.original_filename
  end

  def delete_file
    File.delete(path) if File.exists?(path)
  end

  def self.clean
    destroy_all(["created_at <= ?", Time.now.utc - 10.minutes])
  end

end
