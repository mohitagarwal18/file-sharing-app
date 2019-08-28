class ArtifactsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user,   only: [:destroy , :download]
  def create
    artifact = params[:artifact][:file] rescue nil
    if artifact &&  (artifact.content_type.include?"image")
      if artifact.size <= 100.megabyte  
        file_location = Artifact.create_artifact(artifact , current_user.id)
        if file_location
          saved_artifact = current_user.artifacts.create(file_location:  file_location , file_size: artifact.size, file_name: artifact.original_filename)
          if saved_artifact.errors.any?
            flash[:danger] = saved_artifact.errors.full_messages.join(", ")
          else
            saved_artifact.save
            flash[:success] = "File Uploaded Successfully"
          end
        else
          flash[:danger] = "Upload File Failed"
        end
      else
        flash[:danger] = "Max File Limit is 100MB"
      end
    else
      flash[:danger] = "Invalid File Format"
    end
    redirect_to dashboard_url
  end

  def destroy
    debugger
    if @artifact.delete_artifact
      @artifact.destroy
      flash[:success] = "File Deleted Successfully"
    else
      flash[:danger] = "File Deletion Failed"
    end
    redirect_to dashboard_url
  end
  def download
    send_file @artifact.file_location
  end

  private

    
    def artifact_params
      params.require(:artifact).permit(:file)
    end

end

