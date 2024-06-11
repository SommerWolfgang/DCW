table 6086323 "CEM Expense Inbox"
{
    Caption = 'Expense Inbox';
    Permissions = TableData "CEM Expense" = rimd;

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
            CalcFormula = lookup("CDC Continia User".Name where("User ID" = field("Continia User ID")));
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
        field(6; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(8; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            NotBlank = true;
            TableRelation = "CEM Country/Region";
            ValidateTableRelation = false;
        }
        field(9; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            ValidateTableRelation = false;
        }
        field(11; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(13; "Settlement No."; Code[20])
        {
            Caption = 'Settlement No.';
            TableRelation = "CEM Expense Header"."No." where("Document Type" = const(Settlement),
                                                              "Continia User ID" = field("Continia User ID"));
        }
        field(15; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
        }
        field(16; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
        }
        field(21; "Admin Comment"; Text[250])
        {
            Caption = 'Admin Comment';
        }
        field(29; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
        }
        field(30; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(31; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(50; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(51; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));
        }
        field(52; Billable; Boolean)
        {
            Caption = 'Billable';
        }
        field(60; "Cash/Private Card"; Boolean)
        {
            Caption = 'Cash/Private Card';
        }
        field(93; "Expense Entry No."; Integer)
        {
            Caption = 'Expense Entry No.';
            TableRelation = "CEM Expense";
        }
        field(94; "Imported Date/Time"; DateTime)
        {
            Caption = 'Imported Date Time';
        }
        field(95; "Imported by User ID"; Code[50])
        {
            Caption = 'Imported by';
        }
        field(96; "Processed Date/Time"; DateTime)
        {
            Caption = 'Processed Date Time';
        }
        field(97; "Processed by User ID"; Code[50])
        {
            Caption = 'Processed by';
        }
        field(98; "Error Text"; Text[250])
        {
            Caption = 'Error Text';
        }
        field(99; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Pending,Error,Accepted';
            OptionMembers = Pending,Error,Accepted;

            trigger OnValidate()
            begin
                CheckChangeAndConfirm();
            end;
        }
        field(100; "Expense GUID"; Guid)
        {
            Caption = 'Expense GUID';
        }
        field(101; Filename; Text[250])
        {
            Caption = 'File Name';
        }
        field(102; "Expense Completed"; Boolean)
        {
            Caption = 'Expense Completed';
        }
        field(103; "Continia Online Version No."; Text[100])
        {
            Caption = 'Continia Online Version No.';
        }
        field(112; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(113; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(160; "Transaction ID"; Integer)
        {
            Caption = 'Transaction ID';
            TableRelation = "CEM Bank Transaction";
        }
        field(180; "Expense Type"; Code[20])
        {
            Caption = 'Expense Type';
            TableRelation = "CEM Expense Type";
            ValidateTableRelation = false;
        }
        field(260; "No. of Attachments"; Integer)
        {
            CalcFormula = count("CEM Attachment Inbox" where("Table ID" = const(6086320),
                                                              "Document Type" = const(Budget),
                                                              "Document No." = filter(''),
                                                              "Doc. Ref. No." = field("Entry No.")));
            Caption = 'No. of Attachments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(270; "No. of Attendees"; Integer)
        {
            CalcFormula = count("CEM Attendee Inbox" where("Table ID" = const(6086323),
                                                            "Doc. Ref. No." = field("Entry No.")));
            Caption = 'No. of Attendees';
            Editable = false;
            FieldClass = FlowField;
        }
        field(271; "Expense Header GUID"; Guid)
        {
            Caption = 'Settlement GUID';
        }
        field(272; "Updated By Delegation User"; Code[50])
        {
            Caption = 'Updated By Delegation User';
            TableRelation = "CDC Continia User Setup";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Expense GUID")
        {
        }
        key(Key3; Status, "Processed Date/Time")
        {
        }
        key(Key4; "Expense Header GUID", Status)
        {
        }
        key(Key5; "Expense GUID", Status)
        {
        }
    }

    var
        ExpTypeAttNotReq: Label 'The %1 %2 does not require attendees.';
        StatusChangeQst: Label 'Status changes will lead to version conflicts.\Do you want to continue?';
        Text001: Label 'You cannot modify %1 %2, because it is already accepted.';
        Text002: Label 'You cannot rename a %1.';


    procedure GetAttendeesForDisplay() DisplayTxt: Text[150]
    var
        ExpAttendeeInbox: Record "CEM Attendee Inbox";
    begin
        exit(ExpAttendeeInbox.GetAttendeesForDisplay(DATABASE::"CEM Expense Inbox", "Entry No."));
    end;


    procedure DrillDownAttendees()
    begin
    end;

    procedure GetNoOfEntriesWithError(): Integer
    var
        ExpenseInbox: Record "CEM Expense Inbox";
    begin
        ExpenseInbox.SetCurrentKey(Status);
        ExpenseInbox.SetRange(Status, ExpenseInbox.Status::Error);
        exit(ExpenseInbox.Count);
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

