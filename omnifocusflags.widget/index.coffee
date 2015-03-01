# Set the refresh frequency (milliseconds).
refreshFrequency: 1000 * 60

style: """
  top: 20px
  right: 30px
  color: #fff
  background: rgba(0,0,0,0.3)
  font-family: Helvetica Neue
  font-size: 16px
  font-weight: 500
  width: 500px

  .tasks
	  margin: 0
	  padding: 0
  
  .task
      list-style: none
	  
  .task
	  margin: 0 10px 5px 10px
	  padding: 5px 0 10px 20px
	  white-space: nowrap
	  overflow: hidden
	  text-overflow: ellipsis
	  position: relative
	  opacity: 0.85

  .task-note, .task-project, .task-context
	  position: relative
	  overflow: hidden
	  text-overflow: ellipsis
	  padding: 2px 0 0 0
	  font-size: 12px
	  color: rgba(128,128,128,1)

  .task-project, .task-context
  	  font-weight: bold
  	  color: rgba(212,125,125, 1)

  .task::after
	  content: ""
	  position: absolute
	  width: 10px
	  height: 10px
	  background: rgba(0,0,0,0.2) 
	  -webkit-border-radius: 20px
	  border-style: solid
	  border-color: rgba(255,165,0,1)
	  left: 0px
	  top: 8px

   .count
       padding: 10px
       background: rgba(255,165,0,1)
       width: 10px
       border-top-style: solid
       border-top: thick solid #fff;

    .of-empty
    	width: auto
    	color: #fff
    	text-align: center
    	margin-top: 0
"""

render: (_) -> """
	<div class='count'></div>
	<div id='todos'></div>
"""

command: "osascript './omnifocusflags.widget/of-flaggedTasks.scpt'"

update: (output, domEl) ->
	if output
		@ofObj = JSON.parse(output)
		@_render();
		$(domEl).find('#todos').html(@taskList)
		$(domEl).find('.count').html(@count)
	
_render: () ->
	@count = @ofObj.count;
	@taskList = '<ul class="list">'
	if @ofObj.tasks.length
		@ofObj.tasks.forEach (task) =>
			@taskList +=  '<li class="task">' + 
						task.name +
						'<div>' + @_project(task) + @_context(task) + '</div>' +
						@_note(task) + 
				   	'</li>'
		@taskList += '</ul>'
	else
		@taskList = '<h4 class="of-empty">No Flagged Tasks</h4>'

_project: (task) =>
	return if (task.project and task.project != 'OmniFocus') then '<span class="task-project">' + task.project + '</span>' else ''

_context: (task) =>
	return if task.context then '<span class="task-context"> @ ' + task.context + '</span>' else ''

_note: (task) =>
	return if task.note then '<div class="task-note">' + String(task.note) + '</div>' else ''
	
