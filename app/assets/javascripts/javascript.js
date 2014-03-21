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

var evidenceScore = {
    init: function () {
      $('.indicators').on("ajax:success", this.appendEvidence)
    },
    appendEvidence: function(event, data, status, xhr) {
      $('#evidence-form').remove()
      $('#evidence-form-holder').append(data.evidence_list)
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
    $('#evidence-form-holder').append(data.submit_list)
    $('.dashboard-holder').append(data.domain_percentages)
    $('#blast div').fadeIn('slow')
    $('#blast div').fadeOut(2500)
    $('#blast div').text(data.info)
    $('#blast').css({'display':'block'})
    setCert.documentCert();
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

var setCert = {
  documentCert: function() {
    var qualityWeightedDomainOneFour = parseFloat($('.quality-weighted #0').text())

    if (qualityWeightedDomainOneFour >= 80) {
      $('#observation_read_document_quality').val(2)
    } else {
      $('#observation_read_document_quality').val(1)
    }

    var alignmentWeightedDomainOneFour = parseFloat($('.alignment-weighted #2').text())

    if (alignmentWeightedDomainOneFour >= 75) {
      $('#observation_read_document_alignment').val(2)
    } else {
      $('#observation_read_document_alignment').val(1)
    }
  },

  liveCert: function() {
    var qualityWeightedDomainTwoThree = parseFloat($('.quality-weighted #1').text())

    if (qualityWeightedDomainTwoThree >= 80) {
      $('#observation_read_live_quality').val(2)
    } else {
      $('#observation_read_live_quality').val(1)
    }

    var alignmentWeightedDomainTwoThree = parseFloat($('.alignment-weighted #3').text())

    if (alignmentWeightedDomainTwoThree >= 75) {
      $('#observation_read_live_alignment').val(2)
    } else {
      $('#observation_read_live_alignment').val(1)
    }
  }
}

$(document).ready(function(){
  sideBar.toggle();
  evidenceScore.init();
  submitScore.init();
  docLiveForm.init();
  setCert.documentCert();
  setCert.liveCert();






})