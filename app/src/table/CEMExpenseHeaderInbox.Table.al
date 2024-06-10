table 6086341 "CEM Expense Header Inbox"
{
    Caption = 'Settlement Inbox';
    DataCaptionFields = "Entry No.", Description;

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
        field(7; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(8; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
        }
        field(9; "Expense Header Type"; Option)
        {
            Caption = 'Expense Header Type';
            OptionCaption = 'Budget,Settlement';
            OptionMembers = Budget,Settlement;
        }
        field(10; "Expense Header No."; Code[20])
        {
            Caption = 'Expense Header No.';
            TableRelation = "CEM Expense Header"."No." WHERE("Document Type" = FIELD("Expense Header Type"));
        }
        field(11; "Created Date/Time"; DateTime)
        {
            Caption = 'Created Date Time';
        }
        field(12; "Created by User ID"; Code[50])
        {
            Caption = 'Created by User ID';
        }
        field(13; "Processed Date/Time"; DateTime)
        {
            Caption = 'Processed Date Time';
        }
        field(14; "Processed by User ID"; Code[50])
        {
            Caption = 'Processed by';
        }
        field(15; "Error Text"; Text[250])
        {
            Caption = 'Error Text';
        }
        field(16; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Pending,Error,Accepted';
            OptionMembers = Pending,Error,Accepted;

            trigger OnValidate()
            begin
                CheckChangeAndConfirm;
            end;
        }
        field(17; "Exp. Header GUID"; Guid)
        {
            Caption = 'Exp. Header GUID';
        }
        field(18; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            var
                EMDimMgt: Codeunit "CEM Dimension Mgt.";
            begin
                if Rec.Status = Status::Accepted then
                    Error(AlreadyAcceptedErr, TableCaption, "Entry No.");

                EMDimMgt.UpdateEMDimInboxForGlobalDim(DATABASE::"CEM Expense Inbox", 0, '', "Entry No.", 1, "Global Dimension 1 Code");
            end;
        }
        field(19; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            var
                EMDimMgt: Codeunit "CEM Dimension Mgt.";
            begin
                if Rec.Status = Status::Accepted then
                    Error(AlreadyAcceptedErr, TableCaption, "Entry No.");

                EMDimMgt.UpdateEMDimInboxForGlobalDim(DATABASE::"CEM Expense Inbox", 0, '', "Entry No.", 2, "Global Dimension 2 Code");
            end;
        }
        field(20; "Expense Header Completed"; Boolean)
        {
            Caption = 'Settlement Completed';
        }
        field(21; "Continia Online Version No."; Text[100])
        {
            Caption = 'Continia Online Version No.';
        }
        field(22; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            NotBlank = true;
            TableRelation = "Country/Region";
        }
        field(23; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(24; "Admin Comment"; Text[250])
        {
            Caption = 'Admin Comment';
        }
        field(25; "Departure Date/Time"; DateTime)
        {
            Caption = 'Departure Date/Time';
            NotBlank = true;

            trigger OnValidate()
            begin
                CheckDates;
            end;
        }
        field(26; "Return Date/Time"; DateTime)
        {
            Caption = 'Return Date/Time';

            trigger OnValidate()
            begin
                CheckDates;
            end;
        }
        field(33; Billable; Boolean)
        {
            Caption = 'Billable';
        }
        field(34; "Updated By Delegation User"; Code[50])
        {
            Caption = 'Updated By Delegation User';
            TableRelation = "CDC Continia User Setup";
        }
        field(50; "Pre-approval Amount"; Decimal)
        {
            Caption = 'Pre-approval Amount';
        }
        field(51; "Pre-approval Status"; Option)
        {
            Caption = 'Pre-approval Status';
            OptionMembers = " ",Pending,Approved,Rejected;
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
        key(Key3; "Exp. Header GUID")
        {
        }
        key(Key4; "Exp. Header GUID", Status)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Created Date/Time" := CurrentDateTime;
        "Created by User ID" := UserId;
    end;

    trigger OnModify()
    var
        UserDelegation: Record "CEM User Delegation";
    begin
        if xRec.Status = Status::Accepted then
            Error(AlreadyAcceptedErr, TableCaption, "Entry No.");

        if Status = Status::Error then
            Status := Status::Pending;

        UserDelegation.VerifyUser("Continia User ID");
    end;

    trigger OnRename()
    begin
        Error(CannotRenameErr, TableCaption);
    end;

    var
        AlreadyAcceptedErr: Label 'You cannot modify %1 %2, because it is already accepted.';
        CannotRenameErr: Label 'You cannot rename a %1.';
        DateErr: Label '%1 cannot be earlier than %2.';
        SettlementInboxTableCaption: Label 'Settlement Inbox';
        StatusChangeQst: Label 'Status changes will lead to version conflicts.\Do you want to continue?';


    procedure GetTableCaption(): Text[250]
    begin
        exit(SettlementInboxTableCaption);
    end;

    local procedure CheckDates()
    begin
        if "Departure Date/Time" > "Return Date/Time" then
            Error(DateErr, FieldCaption("Departure Date/Time"), FieldCaption("Return Date/Time"));
    end;


    procedure GetNoOfEntriesWithError(): Integer
    var
        ExpHeaderInbox: Record "CEM Expense Header Inbox";
    begin
        ExpHeaderInbox.SetCurrentKey(Status);
        ExpHeaderInbox.SetRange(Status, ExpHeaderInbox.Status::Error);
        exit(ExpHeaderInbox.Count);
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

