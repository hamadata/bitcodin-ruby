$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib")
require 'bitcodin'
require 'json'

class CreateJobWithMultipleAudioStreams

  # create bitcodinAPI
  @apiKey = "YOUR_API_KEY"

  # INPUT
  @bitAPI  = Bitcodin::BitcodinAPI.new(@apiKey)
  # create http config
  @httpConfig  = Bitcodin::HTTPInputConfig.new('http://path/to/closed/captions/video.mkv')
  begin
    response     = @bitAPI.createInput(@httpConfig)
    responseData = JSON.parse(response)
    @inputId     = responseData['inputId']
  rescue Exception => e
    puts "Could not create Input."
    puts e.message
    puts e.backtrace.inspect
    return nil
  end
  puts "Created input with ID: #{@inputId}."


  # ENCODING PROFILE
  @bitAPI  = Bitcodin::BitcodinAPI.new(@apiKey)
  # create encoding profile
  videoStreamConfig1 = Bitcodin::VideoStreamConfig.new(0, 4800000, Bitcodin::Profile::MAIN, Bitcodin::Preset::PREMIUM, 1080, 1920)
  videoStreamConfig2 = Bitcodin::VideoStreamConfig.new(0, 2400000, Bitcodin::Profile::MAIN, Bitcodin::Preset::PREMIUM, 720, 1280)
  videoStreamConfig3 = Bitcodin::VideoStreamConfig.new(0, 1200000, Bitcodin::Profile::MAIN, Bitcodin::Preset::PREMIUM, 480, 856)
  videoStreamConfigs = [videoStreamConfig1, videoStreamConfig2, videoStreamConfig3]
  audioStreamConfig1 = Bitcodin::AudioStreamConfig.new(0, 256000)
  audioStreamConfig2 = Bitcodin::AudioStreamConfig.new(1, 256000)
  audioStreamConfigs = [audioStreamConfig1, audioStreamConfig2]
  encodingProfile = Bitcodin::EncodingProfile.new('CLOSED CAPTIONS PROFILE', videoStreamConfigs, audioStreamConfigs)
  # parse response to get encoding profile ID
  response           = bitcodinAPI.createEncodingProfile(encodingProfile)
  responseData       = JSON.parse(response)
  @encodingProfileId = responseData['encodingProfileId']



  # JOB
  @bitAPI  = Bitcodin::BitcodinAPI.new(@apiKey)
  # create job config
  manifestTypes = []
  manifestTypes.push(Bitcodin::ManifestType::MPEG_DASH_MPD)
  manifestTypes.push(Bitcodin::ManifestType::HLS_M3U8)

  # create audio metadata
  audioMetaDataConfiguration0 = Bitcodin::AudioMetaDataConfiguration.new(0, 'de', 'Just Sound')
  audioMetaDataConfiguration1 = Bitcodin::AudioMetaDataConfiguration.new(1, 'en', 'Sound and Voice')

  videoMetaDataConfiguration = Bitcodin::VideoMetaDataConfiguration.new(0, 'de', 'German Subtitles')

  @job = Bitcodin::Job.new(@inputId, @encodingProfileId, manifestTypes, 'standard', nil, nil, [audioMetaDataConfiguration0, audioMetaDataConfiguration1], nil, [videoMetaDataConfiguration])

  # create job
  begin
    response     = @bitAPI.createJob(@job)
    responseData = JSON.parse(response)
    @jobId       = responseData['jobId']
  rescue Exception => e
    puts "Could not create Job."
    puts e.message
    puts e.backtrace.inspect
    return nil
  end

  puts "Created job with ID: #{@jobId}."

end
