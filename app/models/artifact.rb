class Artifact < ApplicationRecord
  belongs_to :user
  
  validates :file_name, presence: true, length: { maximum: 255 }
  validates :file_location, presence: true, length: { maximum: 255 }
  before_save :validate_location
  
  def self.create_artifact(artifact , id)
    begin
      dir = Rails.root.join('public', 'uploads', id.to_s)
      Dir.mkdir(dir) unless Dir.exist?(dir)
      File.open(dir.join(artifact.original_filename), 'wb') do |file|
        file.write(artifact.read)
      end
      return dir.join(artifact.original_filename)
    rescue
      return false
    end
  end
        
  def delete_artifact
    if File.exist?(self.file_location)
      File.delete(self.file_location) 
    end
  end


  def validate_location
    if Artifact.where(user_id: self.user_id, file_name: self.file_name ).last
      self.errors.add(:file_name, "Already Exists!") 
      throw(:abort)
    end
    
  end
end