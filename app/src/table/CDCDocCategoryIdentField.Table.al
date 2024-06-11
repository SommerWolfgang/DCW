table 6085759 "CDC Doc. Category Ident. Field"
{
    Caption = 'Identification Field';

    fields
    {
        field(1; "Document Category Code"; Code[10])
        {
            Caption = 'Document Category Code';
            TableRelation = "CDC Document Category";
        }
        field(2; "Table No."; Integer)
        {
            Caption = 'Table No.';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Table));
        }
        field(3; "Field No."; Integer)
        {
            Caption = 'Field No.';
            TableRelation = Field."No." where(TableNo = field("Table No."));
        }
        field(4; "Field Caption"; Text[80])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Table No."),
                                                              "No." = field("Field No.")));
            Caption = 'Field Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; Rating; Integer)
        {
            Caption = 'Rating';
            InitValue = 1;
        }
    }

    keys
    {
        key(Key1; "Document Category Code", "Table No.", "Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        DocCat: Record "CDC Document Category";
    begin
        DocCat.Get("Document Category Code");
        TestField("Table No.", DocCat."Source Table No.");
        TestField("Field No.");
    end;
}

