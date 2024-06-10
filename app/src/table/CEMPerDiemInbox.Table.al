table 6086390 "CEM Per Diem Inbox"
{
    Caption = 'Per Diem Inbox';
    Permissions = TableData "CEM Per Diem" = rimd;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
            TableRelation = "CDC Continia User Setup";
        }
        field(3; "Continia User Name"; Text[50])
        {
            CalcFormula = Lookup("CDC Continia User".Name WHERE("User ID" = FIELD("Continia User ID")));
            Caption = 'Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(5; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(6; "Departure Date/Time"; DateTime)
        {
            Caption = 'Departure Date/Time';
            NotBlank = true;
        }
        field(7; "Return Date/Time"; DateTime)
        {
            Caption = 'Return Date/Time';
        }
        field(9; "Destination Country/Region"; Code[10])
        {
            Caption = 'Destination Country/Region';
            TableRelation = "CEM Country/Region";
        }
        field(10; "Departure Country/Region"; Code[10])
        {
            Caption = 'Departure Country/Region';
            TableRelation = "CEM Country/Region";
        }
        field(13; "Admin Comment"; Text[250])
        {
            Caption = 'Admin Comment';
        }
        field(14; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            var
                EMDimMgt: Codeunit "CEM Dimension Mgt.";
            begin
                if Rec.Status = Status::Accepted then
                    Error(CannotModifyErr, TableCaption, "Entry No.");

                EMDimMgt.UpdateEMDimInboxForGlobalDim(DATABASE::"CEM Per Diem Inbox", 0, '', "Entry No.", 1, "Global Dimension 1 Code");
            end;
        }
        field(15; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            var
                EMDimMgt: Codeunit "CEM Dimension Mgt.";
            begin
                if Rec.Status = Status::Accepted then
                    Error(CannotModifyErr, TableCaption, "Entry No.");

                EMDimMgt.UpdateEMDimInboxForGlobalDim(DATABASE::"CEM Per Diem Inbox", 0, '', "Entry No.", 2, "Global Dimension 2 Code");
            end;
        }
        field(16; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(17; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
        }
        field(18; Billable; Boolean)
        {
            Caption = 'Billable';
        }
        field(19; "Job Line Type"; Option)
        {
            Caption = 'Job Line Type';
            Editable = false;
            OptionCaption = ' ,Budget,Billable,Both Budget and Billable';
            OptionMembers = " ",Schedule,Contract,"Both Schedule and Contract";
        }
        field(21; "Per Diem GUID"; Guid)
        {
            Caption = 'Per Diem GUID';
        }
        field(26; "Settlement No."; Code[20])
        {
            Caption = 'Settlement No.';
            TableRelation = "CEM Expense Header"."No." WHERE("Document Type" = CONST(Settlement),
                                                              "Continia User ID" = FIELD("Continia User ID"));

            trigger OnLookup()
            var
                Settlement: Record "CEM Expense Header";
            begin
            end;

            trigger OnValidate()
            var
                ExpHeader: Record "CEM Expense Header";
            begin
            end;
        }
        field(28; "Per Diem Group Code"; Code[20])
        {
            Caption = 'Per Diem Group Code';
            TableRelation = "CEM Per Diem Group";

            trigger OnValidate()
            var
                ContiniaUserSetup: Record "CDC Continia User Setup";
                BankTransaction: Record "CEM Bank Transaction";
                EMSetup: Record "CEM Expense Management Setup";
                ExpenseType: Record "CEM Expense Type";
                ExpPostingSetup: Record "CEM Posting Setup";
            begin
            end;
        }
        field(29; "Per Diem Completed"; Boolean)
        {
            Caption = 'Per Diem Completed';
        }
        field(30; "Continia Online Version No."; Text[100])
        {
            Caption = 'Continia Online Version No.';
        }
        field(31; "Settlement GUID"; Guid)
        {
            Caption = 'Settlement GUID';
        }
        field(32; "Per Diem Entry No."; Integer)
        {
            Caption = 'Per Diem Entry Number';
            TableRelation = "CEM Per Diem";
        }
        field(33; "Imported Date/Time"; DateTime)
        {
            Caption = 'Imported Date Time';
        }
        field(34; "Imported by User ID"; Code[50])
        {
            Caption = 'Imported by';
        }
        field(35; "Processed Date/Time"; DateTime)
        {
            Caption = 'Processed Date Time';
        }
        field(36; "Processed by User ID"; Code[50])
        {
            Caption = 'Processed by';
        }
        field(37; "Error Text"; Text[250])
        {
            Caption = 'Error Text';
        }
        field(38; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Pending,Error,Accepted';
            OptionMembers = Pending,Error,Accepted;

            trigger OnValidate()
            begin
                CheckChangeAndConfirm;
            end;
        }
        field(39; "Updated By Delegation User"; Code[50])
        {
            Caption = 'Updated By Delegation User';
            TableRelation = "CDC Continia User Setup";
        }
        field(40; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(41; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Status, "Processed Date/Time")
        {
        }
        key(Key3; "Per Diem GUID")
        {
        }
        key(Key4; "Settlement GUID", Status)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        EMDimInbox: Record "CEM Dimension Inbox";
        PerDiem: Record "CEM Per Diem";
        PerDiemValidate: Codeunit "CEM Per Diem-Validate";
    begin
        TestField(Status, Status::Accepted);

        EMDimInbox.SetRange("Table ID", DATABASE::"CEM Per Diem Inbox");
        EMDimInbox.SetRange("Document Type", 0);
        EMDimInbox.SetRange("Document No.", '');
        EMDimInbox.SetRange("Doc. Ref. No.", "Entry No.");
        EMDimInbox.DeleteAll;

        if "Per Diem Entry No." <> 0 then
            if PerDiem.Get("Per Diem Entry No.") then
                PerDiemValidate.Run(PerDiem);
    end;

    trigger OnInsert()
    begin
        "Entry No." := GetEntryNo;
    end;

    trigger OnModify()
    var
        UserDelegation: Record "CEM User Delegation";
    begin
        if xRec.Status = Status::Accepted then
            Error(CannotModifyErr, TableCaption, "Entry No.");

        if Status = Status::Error then
            Status := Status::Pending;

        UserDelegation.VerifyUser("Continia User ID");
    end;

    trigger OnRename()
    begin
        Error(CannotRenameErr, TableCaption);
    end;

    var
        CannotModifyErr: Label 'You cannot modify %1 %2, because it is already accepted.';
        CannotRenameErr: Label 'You cannot rename a %1.';
        StatusChangeQst: Label 'Status changes will lead to version conflicts.\Do you want to continue?';


    procedure GetEntryNo(): Integer
    var
        PerDiemInbox: Record "CEM Per Diem Inbox";
    begin
        if PerDiemInbox.FindLast then
            exit(PerDiemInbox."Entry No." + 1)
        else
            exit(1);
    end;


    procedure GetNoOfEntriesWithError(): Integer
    var
        PerDiemInbox: Record "CEM Per Diem Inbox";
    begin
        PerDiemInbox.SetCurrentKey(Status);
        PerDiemInbox.SetRange(Status, PerDiemInbox.Status::Error);
        exit(PerDiemInbox.Count);
    end;

    local procedure CheckChangeAndConfirm()
    var
        UserSetup: Record "CDC Continia User Setup";
    begin
        if not UserSetup.Get(UserId) then
            Error('');

        if not UserSetup."Approval Administrator" then
            Error('');

        if not Confirm(StatusChangeQst) then
            Error('');
    end;
}
