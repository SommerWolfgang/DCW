table 6085768 "CDC Vendor Post. Group Info"
{
    Caption = 'Vendor Posting Group DC Info.';

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = "Vendor Posting Group";
        }
        field(2; "Payable Account (Allocation)"; Code[20])
        {
            Caption = 'Payable Account (Allocation)';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Payable Account (Allocation)", false, false);
            end;
        }
        field(3; "Purch. Account (Allocation)"; Code[20])
        {
            Caption = 'Purch. Account (Allocation)';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Purch. Account (Allocation)", false, false);
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    local procedure CheckGLAcc(AccNo: Code[20]; CheckProdPostingGroup: Boolean; CheckDirectPosting: Boolean)
    var
        GLAcc: Record "G/L Account";
    begin
        if AccNo <> '' then begin
            GLAcc.Get(AccNo);
            GLAcc.CheckGLAcc;
            if CheckProdPostingGroup then
                GLAcc.TestField("Gen. Prod. Posting Group");
            if CheckDirectPosting then
                GLAcc.TestField("Direct Posting", true);
        end;
    end;


    procedure IsEmptyRec(): Boolean
    begin
        exit(
          ("Payable Account (Allocation)" = '') and
          ("Purch. Account (Allocation)" = ''));
    end;
}

