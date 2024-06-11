table 6086331 "CEM Bank Transaction Inbox"
{
    Caption = 'Bank Transactions Inbox';
    DataCaptionFields = "Entry No.", "Card No.", "Card Name";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; "Card No."; Code[20])
        {
            Caption = 'Card No.';
            TableRelation = "CEM Continia User Credit Card"."Card No.";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UserCreditCard: Record "CEM Continia User Credit Card";
                EMSetup: Record "CEM Expense Management Setup";
            begin
                EMSetup.Get();
                if not EMSetup."Use CC Mapping for dup. Cards" then begin
                    UserCreditCard.SetCurrentKey("Card No.");
                    UserCreditCard.SetRange("Card No.", "Card No.");
                    if not UserCreditCard.IsEmpty then
                        if UserCreditCard.Count = 1 then
                            Validate("Continia User ID", UserCreditCard."Continia User ID")
                end;
            end;
        }
        field(3; "Card Name"; Text[50])
        {
            Caption = 'Card Name';
            Editable = false;
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Document Date"; Date)
        {
            Caption = 'Document Date';
            Editable = false;
        }
        field(7; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(8; "Currency Exch. Rate"; Decimal)
        {
            Caption = 'Currency Exchange Rate';
            DecimalPlaces = 0 : 15;
            Editable = false;
        }
        field(9; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;
        }
        field(10; "Bank-Currency Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Bank-Currency Amount';
            Editable = false;
        }
        field(11; "Entry Type"; Integer)
        {
            Caption = 'Entry Type';
            Editable = false;
        }
        field(12; "Business Category ID"; Code[50])
        {
            Caption = 'Business Category ID';
            Editable = false;
        }
        field(13; "Business No."; Code[20])
        {
            Caption = 'Business No.';
            Editable = false;
        }
        field(14; "Business Name"; Text[250])
        {
            Caption = 'Business Name';
            Editable = false;
        }
        field(15; "Business Address"; Text[80])
        {
            Caption = 'Business Address';
            Editable = false;
        }
        field(16; "Business Address 2"; Text[80])
        {
            Caption = 'Business Address 2';
            Editable = false;
        }
        field(17; "Business Address 3"; Text[80])
        {
            Caption = 'Business Address 3';
            Editable = false;
        }
        field(18; "Business Country/Region"; Code[20])
        {
            Caption = 'Business Country/Region';
            Editable = false;
        }
        field(19; "Business Post Code"; Code[20])
        {
            Caption = 'Business Post Code';
            Editable = false;
        }
        field(20; "Document Time"; Time)
        {
            Caption = 'Document Time';
            Editable = false;
        }
        field(22; "Transaction ID"; Text[150])
        {
            Caption = 'Transaction ID';
            Editable = false;
        }
        field(23; "Travel Passenger Name"; Text[50])
        {
            Caption = 'Travel Passenger Name';
            Editable = false;
        }
        field(24; "Travel Route"; Text[50])
        {
            Caption = 'Travel Route';
            Editable = false;
        }
        field(25; "Travel Departure Date"; Date)
        {
            Caption = 'Travel Departure Date';
            Editable = false;
        }
        field(26; "Travel Return Date"; Date)
        {
            Caption = 'Travel Return Date';
            Editable = false;
        }
        field(27; "Travel Ticket Number"; Text[50])
        {
            Caption = 'Travel Ticket Number';
            Editable = false;
        }
        field(40; "Bank Code"; Code[10])
        {
            Caption = 'Bank Code';
            Editable = false;
            TableRelation = "CEM Bank";
        }
        field(41; "Bank Country/Region"; Code[10])
        {
            Caption = 'Bank Country/Region';
            Editable = false;
            TableRelation = "CEM Bank Agreement"."Country/Region Code" where("Bank Code" = field("Bank Code"));
        }
        field(45; "CO Entry No."; Integer)
        {
            Caption = 'Continia Online Entry No.';
        }
        field(50; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
            TableRelation = "CDC Continia User Setup";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UserCreditCard: Record "CEM Continia User Credit Card";
                EMSetup: Record "CEM Expense Management Setup";
            begin
                if "Continia User ID" = '' then
                    exit;
                EMSetup.Get();
                if not EMSetup."Use CC Mapping for dup. Cards" then begin
                    UserCreditCard.SetCurrentKey("Card No.");
                    UserCreditCard.SetRange("Card No.", "Card No.");
                    UserCreditCard.SetRange("Continia User ID", "Continia User ID");
                    UserCreditCard.FindFirst();
                end;
            end;
        }
        field(51; "Exclude Entry"; Boolean)
        {
            Caption = 'Exclude Entry';
        }
        field(60; "Transaction Type"; Option)
        {
            Caption = 'Transaction Type';
            Editable = false;
            OptionCaption = 'Normal,Balancing';
            OptionMembers = Normal,Balancing;
        }
        field(74; "Bank Statement Transaction"; Boolean)
        {
            Caption = 'Bank Statement Transaction';
            Editable = false;
        }
        field(92; "Try Processed Date/Time"; DateTime)
        {
            Caption = 'Try Processed Date Time';
            Editable = false;
        }
        field(94; "Imported Date/Time"; DateTime)
        {
            Caption = 'Imported Date Time';
            Editable = false;
        }
        field(95; "Imported by User ID"; Code[50])
        {
            Caption = 'Imported by';
            Editable = false;
        }
        field(96; "Processed Date/Time"; DateTime)
        {
            Caption = 'Processed Date Time';
            Editable = false;
        }
        field(97; "Processed by User ID"; Code[50])
        {
            Caption = 'Processed by';
            Editable = false;
        }
        field(98; "Error Text"; Text[250])
        {
            Caption = 'Error Text';
            Editable = false;
        }
        field(99; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Pending,Error,Accepted';
            OptionMembers = Pending,Error,Accepted;
        }
        field(100; "Agreement ID"; Text[30])
        {
            Caption = 'Agreement ID';
            Editable = false;
            TableRelation = "CEM Bank Agreement"."Agreement ID" where("Bank Code" = field("Bank Code"));
        }
        field(120; "Employee No."; Text[50])
        {
            Caption = 'Employee No.';
            Editable = false;
        }
        field(180; "Expense Type"; Code[20])
        {
            Caption = 'Expense Type';
            TableRelation = "CEM Expense Type";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                ExpenseType: Record "CEM Expense Type";
            begin
                ExpenseType.Get("Expense Type");
                Validate("Exclude Entry", ExpenseType."Exclude Transactions");
            end;
        }
        field(250; Duplicate; Boolean)
        {
            Caption = 'Duplicate';
        }
        field(260; "User Paid Credit Card"; Boolean)
        {
            Caption = 'Private Invoiced';
            Editable = false;
        }
        field(261; "Original Posting Date"; Date)
        {
            Caption = 'Original Posting Date';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Status, "Try Processed Date/Time")
        {
        }
        key(Key3; "Bank Code", "Bank Country/Region", Status)
        {
        }
        key(Key4; "Card No.", Status, "Posting Date")
        {
        }
        key(Key5; "Transaction ID")
        {
        }
    }
    procedure MatchCard()
    begin
    end;

    procedure UnMatchCard()
    begin
    end;

    procedure UploadFile(ReconciliationFile: Boolean)
    begin
    end;

    procedure MarkNotDuplicate()
    begin
    end;

    procedure IsDuplicateFromBank(TransactionID: Text[50]; IsStatement: Boolean): Boolean
    begin
    end;

    procedure GetNoOfEntriesWithError(): Integer
    begin
    end;

    procedure PostingDateAllowedCheck()
    begin
    end;
}