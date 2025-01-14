class Student < ApplicationRecord
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :major, presence: true
    validates :graduation_date, presence: true
    validates :school_email, presence: true
    validates :school_email, uniqueness: true
    validate :school_email_format
    has_one_attached :profile_picture, dependent: :purge_later
    validate :acceptable_image
 
    def school_email_format
        unless school_email =~ /\A[\w+\-.]+@msudenver\.edu\z/i
            errors.add(:school_email, "must be an @msudenver.edu email address")
        end
    end
 
    def acceptable_image
        return unless profile_picture.attached?
 
        unless profile_picture.blob.byte_size <= 1.megabyte
            errors.add(:profile_picture, "is too big")
        end
 
        acceptable_types = ["image/jpeg", "image/png"]
        unless acceptable_types.include?(profile_picture.content_type)
            errors.add(:profile_picture, "must be a JPEG or PNG")
        end
 
  end
    VALID_MAJORS = ["Computer Engineering BS", "Computer Information Systems BS",
    "Computer Science BS", "Cybersecurity Major", "Data Science and Machine Learning Major"]

    validates :major, inclusion: { in: VALID_MAJORS, message: "%{value} is not a valid major" }
 end
 
