class QuestionsController < ApplicationController
  # GET /questions
  # GET /questions.xml
  def index

	if (params[:my_questionnaire_id].nil?)
	  @questions = Question.all
	else
	  @questions=Array.new
	  @questionnaire=Questionnaire.find(params[:my_questionnaire_id])
	  @questions = @questionnaire.questions

	end

	  # @questions = Question.all


	respond_to do |format|
	  format.html # index.html.erb                 s
	  format.xml { render :xml => @questions }
	end
  end

	# GET /questions/1
	# GET /questions/1.xml
  def show
	@question = Question.find(params[:id])

	respond_to do |format|
	  format.html # show.html.erb
	  format.xml { render :xml => @question }
	end
  end

	# GET /questions/new
	# GET /questions/new.xml
  def new
	@question = Question.new


	respond_to do |format|
	  format.html # new.html.erb
	  format.xml { render :xml => @question }
	end
  end

	# GET /questions/1/edit
  def edit
	@question = Question.find(params[:id])
  end

	# POST /questions
	# POST /questions.xml
  def create
	@question = Question.new(params[:question])


	respond_to do |format|
	  if @question.save
		format.html { redirect_to(@question, :notice => 'Question was successfully created.') }
		format.xml { render :xml => @question, :status => :created, :location => @question }
	  else
		format.html { render :action => "new" }
		format.xml { render :xml => @question.errors, :status => :unprocessable_entity }
	  end
	end
  end

	# PUT /questions/1
	# PUT /questions/1.xml
  def update
	@question = Question.find(params[:id])

	respond_to do |format|
	  if @question.update_attributes(params[:question])
		format.html { redirect_to(@question, :notice => 'Question was successfully updated.') }
		format.xml { head :ok }
	  else
		format.html { render :action => "edit" }
		format.xml { render :xml => @question.errors, :status => :unprocessable_entity }
	  end
	end
  end

	# DELETE /questions/1
	# DELETE /questions/1.xml
  def destroy
	@question = Question.find(params[:id])
	@question.destroy

	respond_to do |format|
	  format.html { redirect_to(questions_url) }
	  format.xml { head :ok }
	end
  end

  def selection_for_question
	@questionnaire_id=params[:questionnaire_id]
  end

  def use_question
	@question=Question.find(params[:question_id])
	@existing=QuestionnaireQuestion.find(:all, :conditions => ['question_id=? and  questionnaire_id=?', @question.id, params[:questionnaire_id]])

	if (@existing.count==0)
	  @matrices=0
	  @anagram=0
	  @already_present=QuestionnaireQuestion.find_all_by_questionnaire_id(params[:questionnaire_id])
	  @already_present.each do |present|
		question=Question.find(present.question_id)
		if (question.category_id===1)
		  @matrices=@matrices+1
		else
		  @anagram=@anagram+1

		end

	  end
	  @setting_matrix=QuestionnaireSetting.find(:first, :conditions => ['category_id = ?', 1])
	  if (!@setting_matrix.nil?)
		@matrices_max=@setting_matrix.value
	  else
		@matrices_max=100

	  end

	  @setting_anagram=QuestionnaireSetting.find(:first, :conditions => ['category_id = ?', 2])
	  if (!@setting_anagram.nil?)
		@anagram_max=@setting_anagram.value
	  else
		@anagram_max=100

	  end

	  if (@matrices < @matrices_max || @anagram < @anagram_max)


		@questions_questionnaires=QuestionnaireQuestion.new
		@questions_questionnaires.question_id=@question.id
		@questions_questionnaires.questionnaire_id=params[:questionnaire_id]
		if @questions_questionnaires.save!
		  redirect_to questionnaires_path(:notice=>"Question Added Successfully")
		end

	  else

		redirect_to questions_path(:questionnaire_id=>params[:questionnaire_id]), :notice => "Setting Conflicts !"
	  end
	else
	  redirect_to questions_path(:questionnaire_id=>params[:questionnaire_id]), :notice => "This Question is already added !"
	end
  end


  def remove_question
	@question=QuestionnaireQuestion.find_by_question_id(params[:question_id])
	if	@question.update_attribute('questionnaire_id', 0)
	  redirect_to questionnaires_path

	end
  end
end

