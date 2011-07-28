class PlayerAnswersController < ApplicationController
  # GET /player_answers
  # GET /player_answers.xml
  def index
	@player_answers = PlayerAnswer.all

	respond_to do |format|
	  format.html # index.html.erb
	  format.xml { render :xml => @player_answers }
	end
  end

	# GET /player_answers/1
	# GET /player_answers/1.xml
  def show
	@player_answer = PlayerAnswer.find(params[:id])

	respond_to do |format|
	  format.html # show.html.erb
	  format.xml { render :xml => @player_answer }
	end
  end

	# GET /player_answers/new
	# GET /player_answers/new.xml
  def new
	#@player_answer = PlayerAnswer.new
	@student_group=StudentGroup.find_by_facilitator_group_id(current_user.facilitator_group_id)
	@questionnaire=Questionnaire.find(@student_group.pre_questionnaire_id)
	count=@questionnaire.questions.count
	@questions=@questionnaire.questions

	@player_answers=Array.new(count) { PlayerAnswer.new }

	respond_to do |format|
	  format.html # new.html.erb
	  format.xml { render :xml => @player_answer }
	end
  end

	# GET /player_answers/1/edit
  def edit
	@player_answer = PlayerAnswer.find(params[:id])
  end

	# POST /player_answers
	# POST /player_answers.xml
  def create

	@player_answers = params[:player_answers].values.collect { |player_answer| PlayerAnswer.new(player_answer) }



	@sum=0
	s="check_box_"
	for i in 1..25
	  s=s+i.to_s
	  if(!params[s.to_sym].nil?)
		@sum=@sum+params[s.to_sym].to_i
	  end

	  s="check_box_"

	end


	if @player_answers.all?(&:valid?)
	  @player_answers.each do |p|
		if(p.answer.nil?)
		 p.answer=@sum
		end
		p.save


	  end

	end
	  #@student_routing=StudentRouting.find_by_player_id(Player.find_by_game_id(@game.id).id)
	  #@student_routing.pre_neg_taken=true
	  #@student_routing.save

	if @player_answers.all?(&:valid?)
	  respond_to do |format|
		if (params[:questionnaire]=="PreQuestionnaire")
		  format.html { redirect_to :controller => :player_answers, :action => 'new', :questionnaire=>"Quiz" }
		  format.xml { render :xml => @player_answer, :status => :created, :location => @player_answer }
		elsif (params[:questionnaire]=="Quiz")
		  format.html { redirect_to :controller => :player_answers, :action => 'new', :questionnaire=>"PostQuestionnaire" }
		  format.xml { render :xml => @player_answer, :status => :created, :location => @player_answer }
		else
		  format.html { redirect_to root_path }
		  format.xml { render :xml => @player_answer, :status => :created, :location => @player_answer }
		  end

		end
		else
		respond_to do |format|
		  format.html { redirect_to :action => "new", :id=>Player.find_by_user_id(current_user.id), :active_game=>@game.id, :prequestionnaire => 1, :error=>"incomplete form" }
		  format.xml { render :xml => @player_answer.errors, :status => :unprocessable_entity }
		end
	  end
	end


	def createpost

	  @player_answers = params[:player_answers].values.collect { |player_answer| PlayerAnswer.new(player_answer) }

	  if @player_answers.all?(&:valid?)
		@player_answers.each do |p|
		  p.save


		end

	  end
		#@student_routing=StudentRouting.find_by_player_id(Player.find_by_game_id(@game.id).id)
		#@student_routing.post_neg_taken=true
		#@student_routing.save

	  if @player_answers.all?(&:valid?)
		respond_to do |format|
		  format.html { redirect_to root_path }
		  format.xml { render :xml => @player_answer, :status => :created, :location => @player_answer }
		end
	  else
		respond_to do |format|
		  format.html { redirect_to :action => "new" }
		  format.xml { render :xml => @player_answer.errors, :status => :unprocessable_entity }
		end
	  end
	end


	  # PUT /player_answers/1
	  # PUT /player_answers/1.xml
	def update
	  @player_answer = PlayerAnswer.find(params[:id])

	  respond_to do |format|
		if @player_answer.update_attributes(params[:player_answer])
		  format.html { redirect_to(@player_answer, :notice => 'Player answer was successfully updated.') }
		  format.xml { head :ok }
		else
		  format.html { render :action => "edit" }
		  format.xml { render :xml => @player_answer.errors, :status => :unprocessable_entity }
		end
	  end
	end

	  # DELETE /player_answers/1
	  # DELETE /player_answers/1.xml
	def destroy
	  @player_answer = PlayerAnswer.find(params[:id])
	  @player_answer.destroy

	  respond_to do |format|
		format.html { redirect_to(player_answers_url) }
		format.xml { head :ok }
	  end
	end
  end
