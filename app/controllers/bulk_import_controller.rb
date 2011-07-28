class BulkImportController < ApplicationController

  def import
  end


  def pick_data
    require 'spreadsheet'

    @path = Import.save(params[:upload])

    #format
    #first_name last_name email password educator admin facilitator_group_id
    1.times do
      book = Spreadsheet.open "#{@path}"
      sheet1 = book.worksheet 0

      sheet1.each 1 do |sheet|
        @user=User.new
        @user.first_name=sheet[0]
        @user.last_name=sheet[1]
        @user.email=sheet[2]
        @user.password=sheet[3]
        @user.password_confirmation=sheet[3]
        @user.educator=sheet[4]
        @user.admin=sheet[5]
        @users_facilitator = sheet[6]
		@user.facilitator_group_id=FacilitatorGroup.find_by_name(@users_facilitator).id
        @user.save
      end
    end
    #file = File.open("#{@path}")
    #file.close("#{@path}")
    File.delete("#{@path}")
  end

end

