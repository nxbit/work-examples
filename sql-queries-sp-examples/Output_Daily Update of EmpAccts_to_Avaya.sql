/*========================= New Record Data =========================*/
;
/* This Avaya Val is the Val Recived from the Reps Avaya */
/* This is our pivot point for all checks and update of  */
/* any additional profile values.                        */
;
declare @Avaya as varchar(38) = ?;
;
declare @PID as varchar(8) = ?;
declare @PSID as varchar(48) = ?;
declare @LSAM as varchar(64) = ?;
declare @SAM as varchar(64) = ?;
declare @LastUpdatedOn as date = ?;

/*========================= Checking For Existing Avaya to WorkerAccounts Mapping =========================*/
/*========================= Checking For Existing Avaya to PSID Mapping =========================*/
declare @pOwner as varchar(48) = (select PSID from MiningSwap.dbo.EmpAccts_to_Avaya a with(nolock) where a.Avaya = @Avaya);


if @pOwner Is Null
	begin
	/*========================= Inserting New Avaya Record =========================*/
	insert into MiningSwap.dbo.EmpAccts_to_Avaya(Avaya, PID, PSID, LSAM, SAM, LastUpdatedOn)
	select
		@Avaya, 
		case when @PID is null then 'NoAssignment' else @PID end,
		case when @PSID is null then 'NoAssignment' else @PSID end, 
		case when @LSAM is null then 'NoAssignment' else @LSAM end,
		case when @SAM is null then 'NoAssignment' else @SAM end,
		@LastUpdatedOn;
	end
else
/*========================= Updating Existing Avaya Record =========================*/
	begin
	/* Checking if the New Assigned PSID is the same as the Previous Itration */
	if @PSID = @pOwner
		begin
			/* No Record Update is Performed - Same Ownership*/
			select 0;
		end
		else
		/* ======================Its a New Owner====================== */
		begin
			/* Update the Avaya Record */
			update a
			set
				a.PID = case when @PID is null then 'NoAssignment' else @PID end,
				a.PSID = case when @PSID is null then 'NoAssignment' else @PSID end,
				a.LSAM = case when @LSAM is null then 'NoAssignment' else @LSAM end,
				a.SAM = case when @SAM is null then 'NoAssignment' else @SAM end,
				a.LastUpdatedOn = @LastUpdatedOn
			from MiningSwap.dbo.EmpAccts_to_Avaya a with(nolock)
			where a.Avaya = @Avaya;
			select 0;
		end;
	end;