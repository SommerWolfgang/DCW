table 6086410 "CEM Transaction Journal"
{
    Caption = 'Transaction Import Journal';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            MinValue = 1;
            NotBlank = true;
        }
        field(2; "Card No."; Code[20])
        {
            Caption = 'Card No.';
        }
        field(3; "Card Name"; Text[50])
        {
            Caption = 'Card Name';
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(7; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(8; "Currency Exch. Rate"; Decimal)
        {
            Caption = 'Currency Exch. Rate';
            DecimalPlaces = 0 : 15;
        }
        field(9; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';

            trigger OnValidate()
            begin
                UpdateAmountSign();
            end;
        }
        field(10; "Bank-Currency Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Bank-Currency Amount';

            trigger OnValidate()
            begin
                UpdateAmountSign();
            end;
        }
        field(11; "Entry Type"; Integer)
        {
            Caption = 'Entry Type';
        }
        field(12; "Business Category ID"; Code[50])
        {
            Caption = 'Business Category ID';
        }
        field(13; "Business No."; Code[20])
        {
            Caption = 'Business No.';
        }
        field(14; "Business Name"; Text[250])
        {
            Caption = 'Business Name';
        }
        field(15; "Business Address"; Text[80])
        {
            Caption = 'Business Address';
        }
        field(16; "Business Address 2"; Text[80])
        {
            Caption = 'Business Address 2';
        }
        field(17; "Business Address 3"; Text[80])
        {
            Caption = 'Business Address 3';
        }
        field(18; "Business Country/Region"; Code[20])
        {
            Caption = 'Business Country/Region';
        }
        field(19; "Business Post Code"; Code[20])
        {
            Caption = 'Business Post Code';
        }
        field(20; "Document Time"; Time)
        {
            Caption = 'Document Time';
        }
        field(22; "Transaction ID"; Text[50])
        {
            Caption = 'Transaction ID';
        }
        field(23; "Travel Passenger Name"; Text[50])
        {
            Caption = 'Travel Passenger Name';
        }
        field(24; "Travel Route"; Text[50])
        {
            Caption = 'Travel Route';
        }
        field(25; "Travel Departure Date"; Date)
        {
            Caption = 'Travel Departure Date';
        }
        field(26; "Travel Return Date"; Date)
        {
            Caption = 'Travel Return Date';
        }
        field(27; "Travel Ticket Number"; Text[50])
        {
            Caption = 'Travel Ticket Number';
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
        }
        field(100; "Bank Agreement ID"; Text[30])
        {
            Caption = 'Bank Agreement ID';
        }
        field(120; "Employee No."; Text[50])
        {
            Caption = 'Employee No.';
        }
        field(130; "Debit/Credit Identifier"; Text[30])
        {
            Caption = 'Debit/Credit Identifier';

            trigger OnValidate()
            begin
                UpdateAmountSign();
            end;
        }
        field(140; "First Name"; Text[50])
        {
            Caption = 'First Name';
        }
        field(141; "Last Name"; Text[50])
        {
            Caption = 'Last Name';
        }
        field(150; "Template Code"; Code[20])
        {
            Caption = 'Template Code';
            Editable = false;
            TableRelation = "CEM Transaction Template";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        TransactionBuffer: Record "CEM Transaction Journal";
    begin
        if TransactionBuffer.FindLast() then
            Rec."Entry No." := TransactionBuffer."Entry No." + 1
        else
            Rec."Entry No." := 1;
    end;

    var
        DebitCreditIndentifierMissingTxt: Label 'Debit and credit indentifiers are mising.';
        IndentifierUnknownError: Label 'The debit/credit identifier does not match those on the transaction template.';


    procedure Import(Template: Record "CEM Transaction Template")
    begin
    end;


    procedure UpdateAmountSign()
    var
        Template: Record "CEM Transaction Template";
    begin
        if Rec."Debit/Credit Identifier" = '' then
            exit;

        Template.Get(Rec."Template Code");
        if not ((Template."Debit Identifier" <> '') and (Template."Credit Identifier" <> '')) then
            Error(DebitCreditIndentifierMissingTxt);

        case UpperCase(Rec."Debit/Credit Identifier") of
            UpperCase(Template."Debit Identifier"):
                begin
                    Rec.Amount := Abs(Rec.Amount);
                    Rec."Bank-Currency Amount" := Abs("Bank-Currency Amount");
                end;
            UpperCase(Template."Credit Identifier"):
                begin
                    Rec.Amount := Abs(Rec.Amount) * -1;
                    Rec."Bank-Currency Amount" := Abs("Bank-Currency Amount") * -1;
                end;
            else
                Error(IndentifierUnknownError);
        end;
    end;
}

