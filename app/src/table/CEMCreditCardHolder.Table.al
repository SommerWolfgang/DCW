table 6086380 "CEM Credit Card Holder"
{
    Caption = 'Credit Card Holder';

    fields
    {
        field(1; "Card No."; Code[20])
        {
            Caption = 'Card No.';
            NotBlank = true;

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
                UserCreditCard: Record "CEM Continia User Credit Card";
            begin
            end;
        }
        field(2; "Card Name"; Text[50])
        {
            Caption = 'Card Name';
        }
    }

    keys
    {
        key(Key1; "Card No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

