table 6085771 "CDC Gen. Posting Setup Info."
{
    Caption = 'General Posting Setup DC Info.';

    fields
    {
        field(1; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(2; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            NotBlank = true;
            TableRelation = "Gen. Product Posting Group";
        }
        field(3; "Purch. Account (Allocation)"; Code[20])
        {
            Caption = 'Purch. Account (Allocation)';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Purch. Account (Allocation)");
            end;
        }
    }

    keys
    {
        key(Key1; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure IsEmptyRec(): Boolean
    begin
        exit(
          ("Purch. Account (Allocation)" = ''));
    end;

    local procedure CheckGLAcc(AccNo: Code[20])
    var
        GLAcc: Record "G/L Account";
    begin
        if AccNo <> '' then begin
            GLAcc.Get(AccNo);
            GLAcc.CheckGLAcc();
        end;
    end;
}

