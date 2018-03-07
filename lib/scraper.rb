require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(File.read(index_url))

    scraped_students = []

    doc.css(".student-card").each do |student|
      scraped_student = {
        :name => student.css(".student-name").text,
        :location => student.css(".student-location").text,
        :profile_url => student.css("a")[0]['href']
      }

    scraped_students << scraped_student
    end

    scraped_students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(File.read(profile_url))
    student_hash = {}

    social_links = doc.css(".social-icon-container a").collect {|link| link['href']}


    social_links.each do |link|
      if link.include?('twitter')
        student_hash[:twitter] = link
      elsif link.include?('linkedin')
        student_hash[:linkedin] = link
      elsif link.include?('github')
        student_hash[:github] = link
      else
        student_hash[:blog] = link
      end
    end

    student_hash[:profile_quote] = doc.css(".profile-quote").text
    student_hash[:bio] = doc.css(".description-holder p").text

    student_hash
  end
end
