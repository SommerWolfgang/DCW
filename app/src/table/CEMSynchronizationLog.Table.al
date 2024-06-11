table 6086301 "CEM Synchronization Log"
{
    Caption = 'Synchronization Log';
    DataCaptionFields = "Entry No.";

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; "Start Date/Time"; DateTime)
        {
            Caption = 'Start Date/Time';
            Editable = false;
        }
        field(3; "Field Synch."; Boolean)
        {
            Caption = 'Field Synchronization';
            Editable = false;
        }
        field(4; "User ID"; Code[50])
        {
            Caption = 'User ID';
        }
        field(5; "End CO Synch. Date/Time"; DateTime)
        {
            Caption = 'End CO Synch. Date/Time';
        }
        field(6; "End Date/Time"; DateTime)
        {
            Caption = 'End Date/Time';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Field Synch.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Start Date/Time" := CurrentDateTime;
        "User ID" := UserId;
    end;


    procedure StartLogEntry(): BigInteger
    var
        SynchronizationLog: Record "CEM Synchronization Log";
    begin
        SynchronizationLog."Entry No." := GetLastEntryNo();
        SynchronizationLog.Insert(true);
        exit(SynchronizationLog."Entry No.");
    end;


    procedure AppendFieldSynchToLogEntry(EntryNo: BigInteger)
    var
        SynchronizationLog: Record "CEM Synchronization Log";
    begin
        if SynchronizationLog.Get(EntryNo) then begin
            SynchronizationLog."Field Synch." := true;
            SynchronizationLog.Modify(true);
        end;
    end;


    procedure AppendCOSyncEnded(EntryNo: BigInteger)
    var
        SynchronizationLog: Record "CEM Synchronization Log";
    begin
        SynchronizationLog.Get(EntryNo);
        SynchronizationLog."End CO Synch. Date/Time" := CurrentDateTime;
        SynchronizationLog.Modify();
    end;


    procedure FinalizeLogEntry(EntryNo: BigInteger)
    var
        SynchronizationLog: Record "CEM Synchronization Log";
    begin
        if SynchronizationLog.Get(EntryNo) then begin
            SynchronizationLog."End Date/Time" := CurrentDateTime;
            SynchronizationLog.Modify();
        end;
    end;


    procedure CreateFieldSynchLogEntry(EntryNo: BigInteger)
    var
        SynchronizationLog: Record "CEM Synchronization Log";
    begin
        if EntryNo = 0 then begin
            SynchronizationLog."Entry No." := GetLastEntryNo();
            SynchronizationLog."Field Synch." := true;
            SynchronizationLog."End Date/Time" := CurrentDateTime;
            SynchronizationLog.Insert(true);
        end else
            AppendFieldSynchToLogEntry(EntryNo);
    end;


    procedure GetLastFieldSynchDT(): DateTime
    var
        SynchronizationLog: Record "CEM Synchronization Log";
    begin
        SynchronizationLog.SetCurrentKey("Field Synch.");
        SynchronizationLog.SetRange("Field Synch.", true);
        if SynchronizationLog.FindLast() then
            exit(SynchronizationLog."Start Date/Time");
    end;

    local procedure GetLastEntryNo(): BigInteger
    var
        SynchronizationLog: Record "CEM Synchronization Log";
    begin
        if SynchronizationLog.FindLast() then
            exit(SynchronizationLog."Entry No." + 1)
        else
            exit(1);
    end;
}

