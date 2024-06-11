table 6085776 "CDC Std. Amt. Distrib. Dim."
{
    Caption = 'Standard Amount Distribution Dimension';

    fields
    {
        field(1; "Amount Distribution Code"; Code[10])
        {
            Caption = 'Amount Distribution Code';
            NotBlank = true;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            NotBlank = true;
            TableRelation = Dimension;
        }
        field(4; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
            NotBlank = true;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Dimension Code"));

            trigger OnValidate()
            var
                DimValue: Record "Dimension Value";
            begin
                if "Dimension Value Code" <> '' then begin
                    DimValue.Get("Dimension Code", "Dimension Value Code");
                    DimValue.TestField(Blocked, false);
                    DimValue.TestField("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Amount Distribution Code", "Line No.", "Dimension Code")
        {
            Clustered = true;
        }
    }
    procedure UpdateGlobalDimCode(GlobalDimCodeNo: Integer; AmountDistribCode: Code[20]; LineNo: Integer; NewDimValue: Code[20])
    begin
    end;
}