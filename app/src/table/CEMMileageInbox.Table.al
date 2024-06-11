table 6086353 "CEM Mileage Inbox"
{
    Caption = 'Mileage Inbox';
    DataCaptionFields = "Entry No.", "Continia User ID", Description;
    Permissions = TableData "CEM Mileage" = rimd;

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
        field(5; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
            NotBlank = true;
        }
        field(6; "Date Created"; Date)
        {
            Caption = 'Date Created';
        }
        field(8; "From Address"; Text[250])
        {
            Caption = 'From Address';
        }
        field(9; "To Address"; Text[250])
        {
            Caption = 'To Address';
        }
        field(10; "Total Distance"; Decimal)
        {
            Caption = 'Total Distance';
            DecimalPlaces = 0 : 2;
        }
        field(11; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(12; "Calculated Distance"; Decimal)
        {
            Caption = 'Calculated Distance';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(13; Billable; Boolean)
        {
            Caption = 'Billable';
        }
        field(14; "Vehicle Code"; Code[20])
        {
            Caption = 'Vehicle Code';
            TableRelation = "CEM Vehicle";
        }
        field(15; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
        }
        field(16; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
        }
        field(17; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(18; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));
        }
        field(20; "Settlement No."; Code[20])
        {
            Caption = 'Settlement No.';
            TableRelation = "CEM Expense Header"."No." where("Document Type" = const(Settlement),
                                                              "Continia User ID" = field("Continia User ID"));
        }
        field(21; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Pending,Error,Accepted';
            OptionMembers = Pending,Error,Accepted;

            trigger OnValidate()
            begin
                CheckChangeAndConfirm();
            end;
        }
        field(26; "Mileage GUID"; Guid)
        {
            Caption = 'Mileage GUID';
        }
        field(29; "Admin Comment"; Text[250])
        {
            Caption = 'Admin Comment';
        }
        field(30; "Vehicle Registration No."; Text[30])
        {
            Caption = 'Vehicle Registration No.';
        }
        field(31; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(32; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(41; "From Home"; Boolean)
        {
            Caption = 'From Home';
        }
        field(42; "To Home"; Boolean)
        {
            Caption = 'To Home';
        }
        field(50; "Travel Time"; Decimal)
        {
            Caption = 'Travel Time';
        }
        field(72; "From Address Latitude"; Decimal)
        {
            Caption = 'From Address Latitude';
        }
        field(73; "From Address Longitude"; Decimal)
        {
            Caption = 'From Address Longitude';
        }
        field(74; "To Address Latitude"; Decimal)
        {
            Caption = 'To Address Latitude';
        }
        field(75; "To Address Longitude"; Decimal)
        {
            Caption = 'To Address Longitude';
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
        field(100; "Mileage Entry No."; Integer)
        {
            Caption = 'Mileage Entry No.';
            TableRelation = "CEM Mileage";
        }
        field(101; "Mileage Completed"; Boolean)
        {
            Caption = 'Mileage Completed';
        }
        field(102; "Continia Online Version No."; Text[100])
        {
            Caption = 'Continia Online Version No.';
        }
        field(103; "Expense Header GUID"; Guid)
        {
            Caption = 'Settlement GUID';
        }
        field(122; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(123; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(260; "No. of Attachments"; Integer)
        {
            CalcFormula = count("CEM Attachment Inbox" where("Table ID" = const(6086353),
                                                              "Document Type" = const(Budget),
                                                              "Document No." = filter(''),
                                                              "Doc. Ref. No." = field("Entry No.")));
            Caption = 'No. of Attachments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(270; "No. of Attendees"; Integer)
        {
            CalcFormula = count("CEM Attendee Inbox" where("Table ID" = const(6086353),
                                                            "Doc. Ref. No." = field("Entry No.")));
            Caption = 'No. of Attendees';
            Editable = false;
            FieldClass = FlowField;
        }
        field(271; "Updated By Delegation User"; Code[50])
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
        key(Key2; "Mileage GUID")
        {
        }
        key(Key3; Status, "Processed Date/Time")
        {
        }
        key(Key4; "Expense Header GUID", Status)
        {
        }
        key(Key5; "Mileage GUID", Status)
        {
        }
    }

    var
        ModifyAcceptedNotAllowed: Label 'You cannot modify %1 %2, because it is already accepted.';
        RenameNotAllowed: Label 'You cannot rename a %1.';
        StatusChangeQst: Label 'Status changes will lead to version conflicts.\Do you want to continue?';


    procedure ConvertDistance(FromUnit: Option Km,Miles; var Value: Decimal)
    begin
        case FromUnit of
            FromUnit::Km:
                Value := Round(Value / MilesPrKm(), 0.00001);
            FromUnit::Miles:
                Value := Round(Value * MilesPrKm(), 0.00001);
        end;
    end;


    procedure MilesPrKm(): Decimal
    begin
        exit(1.609344);
    end;


    procedure DrillDownAttendees()
    begin
    end;


    procedure GetAttendeesForDisplay() DisplayTxt: Text[150]
    var
        ExpAttendeeInbox: Record "CEM Attendee Inbox";
    begin
        exit(ExpAttendeeInbox.GetAttendeesForDisplay(DATABASE::"CEM Mileage Inbox", "Entry No."));
    end;


    procedure GetNoOfEntriesWithError(): Integer
    var
        MileageInbox: Record "CEM Mileage Inbox";
    begin
        MileageInbox.SetCurrentKey(Status);
        MileageInbox.SetRange(Status, MileageInbox.Status::Error);
        exit(MileageInbox.Count);
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

