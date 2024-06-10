table 6086396 "CEM Release Notification Entry"
{
    Caption = 'Notification Outbox';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            Editable = false;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Table));

            trigger OnLookup()
            var
                TempObject: Record AllObj temporary;
            begin
            end;

            trigger OnValidate()
            var
                TempObject: Record AllObj temporary;
            begin
            end;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;

            trigger OnLookup()
            var
                Expense: Record "CEM Expense";
                ExpHeader: Record "CEM Expense Header";
                Mileage: Record "CEM Mileage";
                PerDiem: Record "CEM Per Diem";
                EMApprovalMgt: Codeunit "CEM Approval Management";
            begin
                LookupCard(Rec);
            end;
        }
        field(10; "Table Name"; Text[249])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Table),
                                                                           "Object ID" = FIELD("Table ID")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(35; "Processed Date/Time"; DateTime)
        {
            Caption = 'Processed Date Time';
            Editable = false;
        }
        field(36; "Created Date/Time"; DateTime)
        {
            Caption = 'Created Date Time';
            Editable = false;
        }
        field(37; "Error Text"; Text[250])
        {
            Caption = 'Error Text';
        }
        field(38; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Pending,Error,Ignore,Accepted';
            OptionMembers = Pending,Error,Ignore,Accepted;
        }
        field(39; "Document for History"; Boolean)
        {
            Caption = 'Document for History';
        }
        field(50; "No. of Attempts"; Integer)
        {
            Caption = 'No. of Attempts';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Status)
        {
        }
        key(Key3; "Table ID", "Document No.", Status, "Document for History")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Entry No." := GetEntryNo;
        "Created Date/Time" := CurrentDateTime;
    end;

    trigger OnRename()
    var
        RenameError: Label 'You cannot rename a %1.';
    begin
        Error(RenameError, TableCaption);
    end;


    procedure GetEntryNo(): Integer
    var
        Entry: Record "CEM Release Notification Entry";
    begin
        if Entry.FindLast then
            exit(Entry."Entry No." + 1)
        else
            exit(1);
    end;


    procedure InsertReleaseNotificationEntry(TableID: Integer; DocumentNo: Code[20]; HistoryDocument: Boolean)
    begin
        if PendingEntryExists(TableID, DocumentNo, HistoryDocument) then
            exit;

        Init;
        "Table ID" := TableID;
        "Document No." := DocumentNo;
        "Document for History" := HistoryDocument;
        Insert(true);
    end;


    procedure SetIgnoreStatusMultiple(var ReleaseNotificationEntry: Record "CEM Release Notification Entry")
    begin
        if ReleaseNotificationEntry.FindSet then
            repeat
                ReleaseNotificationEntry.TestField(Status, ReleaseNotificationEntry.Status::Error);
            until ReleaseNotificationEntry.Next = 0;

        ReleaseNotificationEntry.ModifyAll(Status, ReleaseNotificationEntry.Status::Ignore);
    end;


    procedure ResetStatusAll(var Entry: Record "CEM Release Notification Entry")
    begin
        Entry.SetCurrentKey(Status);
        Entry.SetRange(Status, Status::Error);
        Entry.ModifyAll("No. of Attempts", 0);
        Entry.ModifyAll("Error Text", '');
        Entry.ModifyAll(Status, Status::Pending);
    end;


    procedure LookupCard(Entry: Record "CEM Release Notification Entry")
    var
        Expense: Record "CEM Expense";
        ExpHeader: Record "CEM Expense Header";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
        EMApprovalMgt: Codeunit "CEM Approval Management";
    begin
        case Entry."Table ID" of

            DATABASE::"CEM Expense":
                if Expense.Get(EMApprovalMgt.Code2Int(Entry."Document No.")) then
                    Expense.OpenDocumentCard;

            DATABASE::"CEM Mileage":
                if Mileage.Get(EMApprovalMgt.Code2Int(Entry."Document No.")) then
                    Mileage.OpenDocumentCard;

            DATABASE::"CEM Per Diem":
                if PerDiem.Get(EMApprovalMgt.Code2Int(Entry."Document No.")) then
                    PerDiem.OpenDocumentCard;

            DATABASE::"CEM Expense Header":
                if ExpHeader.Get(ExpHeader."Document Type"::Settlement, Entry."Document No.") then
                    ExpHeader.OpenDocumentCard;

        end;
    end;


    procedure CheckForUnprocessedEntries(): Boolean
    begin
        Reset;
        SetCurrentKey(Status);
        SetRange(Status, Status::Pending, Status::Error);
        SetRange("Document for History", false);
        SetRange("Created Date/Time", 0DT, CurrentDateTime - (24 * 60 * 60 * 1000));
        exit(not IsEmpty);
    end;


    procedure CheckForUnprocessedHistEntries(): Boolean
    begin
        Reset;
        SetCurrentKey(Status);
        SetRange(Status, Status::Pending, Status::Error);
        SetRange("Document for History", true);
        exit(not IsEmpty);
    end;

    local procedure PendingEntryExists(TableID: Integer; DocumentNo: Code[20]; HistoryDocument: Boolean): Boolean
    var
        ReleaseNotificationEntry: Record "CEM Release Notification Entry";
    begin
        ReleaseNotificationEntry.SetCurrentKey("Table ID", "Document No.", Status, "Document for History");
        ReleaseNotificationEntry.SetRange("Table ID", TableID);
        ReleaseNotificationEntry.SetRange("Document No.", DocumentNo);
        ReleaseNotificationEntry.SetRange(Status, ReleaseNotificationEntry.Status::Pending);
        ReleaseNotificationEntry.SetRange("Document for History", HistoryDocument);

        exit(not ReleaseNotificationEntry.IsEmpty);
    end;
}

