#$RawTeamsMeetingPolicies = Get-CSTeamsMeetingPolicy

ConvertFrom-Json -InputObject @'
[
  {
    "Name": "AdmitAnonymousUsersByDefault",
    "Description": "Controls whether anonymous users are admitted to the meeting by default.",
    "ConfigurationOptions": "True or False"

  },
  {
    "Name": "AllowAnnotations",
    "Description": "Enables or disables the use of annotations during meetings.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowAnonymousUsersToDialOut",
    "Description": "Controls whether anonymous users are allowed to dial out during meetings.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowAnonymousUsersToJoinMeeting",
    "Description": "Determines if anonymous users can join the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowAnonymousUsersToStartMeeting",
    "Description": "Controls whether anonymous users can start the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowAvatarsInGallery",
    "Description": "Controls the display of avatars in the meeting gallery view.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowBreakoutRooms",
    "Description": "Enables or disables the use of breakout rooms during meetings.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowCarbonSummary",
    "Description": "Determines if carbon summaries are allowed in the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowCartCaptionsScheduling",
    "Description": "Controls whether live captions can be scheduled for the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowChannelMeetingScheduling",
    "Description": "Enables or disables scheduling meetings in a channel.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowCloudRecording",
    "Description": "Determines if cloud recording is enabled for the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowDocumentCollaboration",
    "Description": "Controls the ability to collaborate on documents during the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowedPrivateMeetingScheduling",
    "Description": "Specifies who can schedule private meetings.",
    "ConfigurationOptions": "Everyone or OrganizerOnly"
  },
  {
    "Name": "AllowedStreamingMediaInput",
    "Description": "Controls the ability to input streaming media during the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowEngagementReport",
    "Description": "Enables or disables the engagement report for the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowExternalNonTrustedMeetingChat",
    "Description": "Controls whether external participants can chat in the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowExternalParticipantGiveRequestControl",
    "Description": "Determines if external participants can request control during the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowImmersiveView",
    "Description": "Enables or disables the use of immersive view during the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowIPAudio",
    "Description": "Specifies the mode for using IP audio in the meeting.",
    "ConfigurationOptions": "Disabled, IPOnly, or PSTNOnly"
  },
  {
    "Name": "AllowIPVideo",
    "Description": "Specifies the mode for using IP video in the meeting.",
    "ConfigurationOptions": "Disabled, All, or PSTNOnly"
  },
  {
    "Name": "AllowMeetingCoach",
    "Description": "Controls whether the meeting coach is enabled for the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowMeetingReactions",
    "Description": "Enables or disables meeting reactions for participants.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowMeetingRegistration",
    "Description": "Determines if meeting registration is required for the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowMeetNow",
    "Description": "Enables or disables the ability to start impromptu meetings.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowNDIStreaming",
    "Description": "Controls the use of NDI streaming during the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowNetworkConfigurationSettingsLookup",
    "Description": "Enables or disables network configuration settings lookup for the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowOrganizersToOverrideLobbySettings",
    "Description": "Determines if organizers can override lobby settings for the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowOutlookAddIn",
    "Description": "Enables or disables the Microsoft Outlook add-in for Teams meetings.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowParticipantGiveRequestControl",
    "Description": "Controls whether participants can request control during the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowPowerPointSharing",
    "Description": "Enables or disables PowerPoint sharing during the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowPrivateMeetingScheduling",
    "Description": "Determines if private meeting scheduling is allowed.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowPrivateMeetNow",
    "Description": "Enables or disables the ability to start private impromptu meetings.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowPSTNUsersToBypassLobby",
    "Description": "Controls whether PSTN users can bypass the lobby and join the meeting directly.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowRecordingStorageOutsideRegion",
    "Description": "Determines if meeting recordings can be stored outside the region.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowScreenContentDigitization",
    "Description": "Controls the ability to digitize screen content during the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowSharedNotes",
    "Description": "Enables or disables the use of shared notes during the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowTasksFromTranscript",
    "Description": "Controls whether participants can create tasks from meeting transcripts.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowTeamsMeeting",
    "Description": "Enables or disables the use of Teams meetings.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowTrackingInReport",
    "Description": "Determines if user tracking is included in the meeting report.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowTranscription",
    "Description": "Enables or disables the transcription feature for the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowUserToJoinExternalMeeting",
    "Description": "Controls whether users can join external meetings.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowWatermarkCustomizationForCameraVideo",
    "Description": "Determines if customization of the watermark for camera video is allowed.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowWatermarkCustomizationForScreenSharing",
    "Description": "Specifies if customization of the watermark for screen sharing is allowed.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowWatermarkForCameraVideo",
    "Description": "Controls the display of a watermark on camera video during meetings.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowWatermarkForScreenSharing",
    "Description": "Determines if a watermark is displayed on screen sharing during meetings.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AllowWhiteboard",
    "Description": "Enables or disables the use of whiteboard during the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AppDesktopSharingMode",
    "Description": "Specifies the mode for sharing app windows or the entire desktop during meetings.",
    "ConfigurationOptions": "Disabled, Presenter, or EntireScreen"
  },
  {
    "Name": "AudibleRecordingNotification",
    "Description": "Controls whether an audible notification is played when recording starts or stops.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "AutoAdmittedUsers",
    "Description": "Specifies the users who are auto-admitted to the meeting.",
    "ConfigurationOptions": "Everyone, EveryoneInCompany, or OrganizerOnly"
  },
  {
    "Name": "BlockedAnonymousJoinClientTypes",
    "Description": "Specifies the client types that are blocked for anonymous join.",
    "ConfigurationOptions": "List of client types"
  },
  {
    "Name": "ChannelRecordingDownload",
    "Description": "Enables or disables the ability to download channel recordings.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "Description",
    "Description": "The description of the meeting policy.",
    "ConfigurationOptions": "String"
  },
  {
    "Name": "DesignatedPresenterRoleMode",
    "Description": "Specifies the role mode for designated presenters in the meeting.",
    "ConfigurationOptions": "Everyone or OrganizerOnly"
  },
  {
    "Name": "EnableAppDesktopSharing",
    "Description": "Enables or disables sharing of app windows during desktop sharing.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "EnableLowBandwidthConsumption",
    "Description": "Determines if low bandwidth consumption mode is enabled for the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "EnableOutlookAddIn",
    "Description": "Enables or disables the Microsoft Outlook add-in for Teams meetings.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "EnrollUserOverride",
    "Description": "Specifies if user enrollment is overridden for the meeting.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "ExplicitRecordingConsent",
    "Description": "Controls whether explicit consent is required for meeting recording.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "ForceStreamingAttendeeMode",
    "Description": "Specifies the attendee mode for forced streaming.",
    "ConfigurationOptions": "Everyone or OrganizerOnly"
  },
  {
    "Name": "Identity",
    "Description": "The identity of the meeting policy.",
    "ConfigurationOptions": "String"
  },
  {
    "Name": "InfoShownInReportMode",
    "Description": "Specifies the information shown in the meeting report.",
    "ConfigurationOptions": "Organizer, OrganizerAndParticipants, or Everyone"
  },
  {
    "Name": "IPAudioMode",
    "Description": "Specifies the mode for IP audio in the meeting.",
    "ConfigurationOptions": "Disabled, PSTNOnly, or All"
  },
  {
    "Name": "IPVideoMode",
    "Description": "Specifies the mode for IP video in the meeting.",
    "ConfigurationOptions": "Disabled, PSTNOnly, or All"
  },
  {
    "Name": "LiveCaptionsEnabledType",
    "Description": "Determines if live captions are enabled for the meeting.",
    "ConfigurationOptions": "Disabled, All, or PSTNOnly"
  },
  {
    "Name": "LiveInterpretationEnabledType",
    "Description": "Determines if live interpretation is enabled for the meeting.",
    "ConfigurationOptions": "Disabled, All, or PSTNOnly"
  },
  {
    "Name": "LiveStreamingMode",
    "Description": "Specifies the mode for live streaming in the meeting.",
    "ConfigurationOptions": "Disabled, Public, or Internal"
  },
  {
    "Name": "MediaBitRateKb",
    "Description": "Specifies the media bit rate in kilobits per second (kbps).",
    "ConfigurationOptions": "Integer"
  },
  {
    "Name": "MeetingChatEnabledType",
    "Description": "Controls whether meeting chat is enabled for participants.",
    "ConfigurationOptions": "EnabledForEveryone, EnabledForInternal, or DisabledForAll"
  },
  {
    "Name": "MeetingInviteLanguage1",
    "Description": "Specifies the primary language for meeting invitations.",
    "ConfigurationOptions": "String"
  },
  {
    "Name": "MeetingInviteLanguage2",
    "Description": "Specifies the secondary language for meeting invitations.",
    "ConfigurationOptions": "String"
  },
  {
    "Name": "MeetingInviteLanguages",
    "Description": "Specifies the list of languages for meeting invitations.",
    "ConfigurationOptions": "List of languages"
  },
  {
    "Name": "MeetingRecordingExpirationDays",
    "Description": "Specifies the number of days before meeting recordings expire.",
    "ConfigurationOptions": "Integer"
  },
  {
    "Name": "NewMeetingRecordingExpirationDays",
    "Description": "Specifies the number of days before new meeting recordings expire.",
    "ConfigurationOptions": "Integer"
  },
  {
    "Name": "PreferredMeetingProviderForIslandsMode",
    "Description": "Specifies the preferred meeting provider for islands mode.",
    "ConfigurationOptions": "Teams, SkypeForBusiness, or None"
  },
  {
    "Name": "RecordingStorageMode",
    "Description": "Specifies the storage mode for meeting recordings",
    "ConfigurationOptions": "OneDriveForBusiness or SharePoint"
  }
  {
    "Name": "RoomAttributeUserOverride",
    "Description": "Specifies if room attribute user override is enabled.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "RoomPeopleNameUserOverride",
    "Description": "Specifies if room people name user override is enabled.",
    "ConfigurationOptions": "True or False"
  },
  {
    "Name": "ScreenSharingMode",
    "Description": "Specifies the mode for screen sharing during the meeting.",
    "ConfigurationOptions": "Disabled, Presenter, or EntireScreen"
  },
  {
    "Name": "SpeakerAttributionMode",
    "Description": "Specifies the mode for speaker attribution in the meeting.",
    "ConfigurationOptions": "Disabled, OnAgenda, or All"
  },
  {
    "Name": "StreamingAttendeeMode",
    "Description": "Specifies the attendee mode for streaming.",
    "ConfigurationOptions": "Everyone or OrganizerOnly"
  },
  {
    "Name": "TeamsCameraFarEndPTZMode",
    "Description": "Specifies the mode for Teams camera far end pan-tilt-zoom (PTZ).",
    "ConfigurationOptions": "Disabled, OrganizerOnly, or Everyone"
  },
  {
    "Name": "VideoFiltersMode",
    "Description": "Specifies the mode for video filters in the meeting.",
    "ConfigurationOptions": "Disabled, Everyone, or OrganizerOnly"
  },
  {
    "Name": "WatermarkForCameraVideoOpacity",
    "Description": "Specifies the opacity of the watermark for camera video.",
    "ConfigurationOptions": "Integer"
  },
  {
    "Name": "WatermarkForCameraVideoPattern",
    "Description": "Specifies the pattern of the watermark for camera video.",
    "ConfigurationOptions": "String"
  },
  {
    "Name": "WatermarkForScreenSharingOpacity",
    "Description": "Specifies the opacity of the watermark for screen sharing.",
    "ConfigurationOptions": "Integer"
  },
  {
    "Name": "WatermarkForScreenSharingPattern",
    "Description": "Specifies the pattern of the watermark for screen sharing.",
    "ConfigurationOptions": "String"
  },
  {
    "Name": "WhoCanRegister",
    "Description": "Specifies who can register for the meeting.",
    "ConfigurationOptions": "Everyone, EveryoneInCompany, or OrganizerOnly"
  }
]
'@