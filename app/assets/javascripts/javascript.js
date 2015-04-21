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


$(document).ready(function(){
  sideBar.toggle();
  evidenceScore.init();
  docLiveForm.init();
  indicatorLinks.highlight();
  $('#finalize-button').on('click', LogIn.displayIt)
  $('.fa-times-circle').on('click', LogIn.hide)
  $('#cancel-read').on('click', LogIn.hide)
  $('#observation-read-button').on('click', LogIn.hide)
})
