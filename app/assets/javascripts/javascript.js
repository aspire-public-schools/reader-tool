var sideBar = {
  toggle: function () {
    $('dl').on('click', 'dt', function(){
      var $this = $(this),
        $firstGroup = $this.nextUntil('dt');
      $firstGroup.toggle('fast', 'swing');
      $this.siblings('dd').not($firstGroup).hide()
    })
  }
}

var indicatorLinks = {
  highlight: function() {
    var classHighlight = 'highlight-current'
      var $indicators = $('dd').on('click', function(e){
        e.preventDefault()
        $indicators.removeClass(classHighlight)
        $(this).addClass(classHighlight)
    })
  }
}

var evidenceScore = {
    init: function () {
      $('.indicators').on("ajax:success", this.appendEvidence)
    },
    appendEvidence: function(event, data, status, xhr) {
      $('#evidence-form').remove()
      $('#evidence-form-holder').append(data.evidence_list).siblings('.row').hide()
      scrollOn.indicator()
    }
}

var submitScore = {
  init: function () {
    $('#evidence-form-holder').on("ajax:success", '#evidence-form', this.submitScoreAndDashboard)
  },
  submitScoreAndDashboard: function(event, data, status, xhr){
    $('#evidence-form').remove()
    $('#domain-table').remove()
    $('#domain-table-weighted').remove()
    var $indicator = $("." + data.indicator.toString())
    $indicator.parent().css('background-color', '#27ae60')
    $('#evidence-form-holder').append(data.submit_list)
    $('.dashboard-holder').append(data.domain_percentages)
    scrollOn.submit()
    $('#blast div').fadeIn('slow')
    $('#blast div').fadeOut(4000)
    $('#blast div').text(data.info)
    $('#blast').css({'display':'block'})
  }
}

var docLiveForm = {
  init: function() {
    $('.document-live-form-holder').on("ajax:success", this.updateDocLiveForm)
  },
  updateDocLiveForm: function(event, data, status, xhr){
    $('#submit-message').fadeIn('slow')
    $('#submit-message').fadeOut(2500)
    $('#submit-message').text(data.saved_message)
    $('.alert-success p').css({'display':'block'})
  }
}

var scrollOn = {
  indicator: function(){
    var $mainDashboard = $('.main-dashboard').position().top
    $('body').animate({scrollTop: $mainDashboard}, 300)
  },
  submit: function(){
    debugger
    $('html body').animate({ scrollTop: 0 }, 600);
  }
}

var LogIn = {
  displayIt: function(){
    $('.login_modal').css('display','block')
  },
  hide: function(){
    $('.login_modal').css('display','none')
  }
}

var observationAdmin = {
  highlightGreen: function(){
    if ( $('.admin-form td.two') ) {
      $('td.two').css('background-color', '#1abc9c')
    }
  },
  highlightGrey: function(){
    if ( $('.admin-form td.three') ){
      $('td.three').css('background-color', '#7f8c8d')
    }
  },
  highlightYellow: function(){
    if ( $('.admin-form td.one') ){
      $('td.one').css('background-color', '#f1c40f')
    }
  }
}


$(document).ready(function(){
  observationAdmin.highlightGreen();
  observationAdmin.highlightYellow();
  observationAdmin.highlightGrey();
  sideBar.toggle();
  evidenceScore.init();
  submitScore.init();
  docLiveForm.init();
  indicatorLinks.highlight();
  $('#finalize-button').on('click', LogIn.displayIt)
  $('.fa-times-circle').on('click', LogIn.hide)
  $('#cancel-read').on('click', LogIn.hide)
  $('#observation-read-button').on('click', LogIn.hide)
})
