# Understanding WavePlanner

The WavePlanner spreadsheet is used to plan out migration waves for Exchange mailboxes from one or more Exchange source organizations to one or more target Exchange organizations.  It is a tool for both the initial planning and for tracking of ongoing exceptions and special handling scenarios for migration wave assignments.

## WavePlanner Worksheets

The following worksheets are part of the WavePlanner:

### Waveplan

This sheet is used to map out Migration Waves and also, if desired, per wave Migration state (synced/completed).

The expected columns for this sheet are the following:

- Wave:  Contains the wave numbers in x.x format.  The wave number can be derived from a WaveGroup and SubWave (useful for multiple waves per time period, such as a week) or can be independently entered.
- TargetDate:  The actual target date for cutover activities for the wave
- T-x Date Columns:  One or more T-x columns for dates based on the target date. For example, often specific activities must take place on x +/- days in relation to TargetDate.  Most migration projects have a T-10, a T-5, and a T-1 as well as a T+1.  These columns are best configured to auto calculate the date based on the target date.

Optional columns for this sheet are the following:

- SyncInitiated: TRUE/FALSE for whether the Migration Batch has been initiated for the wave
- MigrationCompleted: TRUE/FALSE for whether the Migration cutover has been completed

### WaveAssignments

This sheet is used to map groups of users to specific Migration Waves.

The expected columns for this sheet are the following

- Name: Name for the group of users.  Sometimes this is a department name, a division name, or the name of an AD group, or a combination thereof.
- MailboxCount:  Approximate number of mailboxes included in the group for estimation of migration wave size
- AssignedWave: Migration Wave to which the group is assigned.
- TargetDate: Sourced from the WavePlan sheet via XLOOKUP function

### PlanAssignmentsReport

This sheet contains a pivot table which sums the mailboxes by migration wave based on WaveAssignments for estimation of wave size in terms of mailboxes as well as visualization of the planned migration schedule. If changes are made to the WavePlan or WaveAssignments, refresh the pivot table so show the updated report.

### WaveExceptions

This sheet is for tracking exceptions to the WaveAssignments where it is necessary to override the group based assignments from WaveAssignments in order to migrate a mailbox with an earlier or later wave or to assign a mailbox that is outside the scope of the WaveAssignments.

Expected Columns:

- PrimarySMTPAddress
- OriginalWave (optional)
- AssignedWave: the override wave assignment for the mailbox
- Reason:  A reason for the assignment override
- ApprovedByEmailAddress: who approved the override
- DateAdded: when the override exception was added
- DateModified:  if the override is later changed rather than removed, the DateModified can be used to track the change date.

Exceptions that are no longer needed should be deleted by removal of the entire row from the table and the MigrationList / AssignedWave should be updated with the group based wave assignement and the WaveAssignmentSource should be updated to the value "WaveAssignments"

NOTE: There should only be one entry per a given mailbox on this sheet.  The AssignedWave from this list should be updated for the mailbox in the MigrationList / AssignedWave and the WaveAssignmentSource should be updated to the value "WaveExceptions"

### SpecialHandling

 This sheet is for tracking "Special Handling" requirements for mailboxes.

 Expected Columns:

 - PrimarySMTPAddress
 - Description:  What is the "Special Handling" scenario being noted?
 - AddedBy: Who authorized or is responsible for the "Special Handling" entry
 - DateAdded: When the "Special Handling" note was created for the mailbox

 NOTE: there can be more than one entry per mailbox.  The description from these entries should be updated in MigrationList / SpecialHandling

 ### Messages

 This sheet lists the communications to be sent as part of migration wave communications to the migration wave members.  