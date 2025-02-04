Gather.Views.Meals.RoleFormView = Backbone.View.extend

  initialize: (options) ->
    @$('#meals_role_time_type').trigger('change')

  events:
    'change #meals_role_time_type': 'toggleOffsetsAndHours'

  toggleOffsetsAndHours: ->
    @$('.form-group.meals_role_shift_start').toggle(@isDateTime())
    @$('.form-group.meals_role_shift_end').toggle(@isDateTime())
    @$('.form-group.meals_role_work_hours').toggle(!@isDateTime())

  isDateTime: ->
    @timeType() == 'date_time'

  timeType: ->
    @$('#meals_role_time_type').val()
