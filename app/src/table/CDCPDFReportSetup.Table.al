table 6086012 "CDC PDF Report Setup"
{
    Caption = 'PDF Report Setup';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
            TableRelation = AllObj."Object ID" where("Object Type" = const(Table));

            trigger OnValidate()
            begin
                CalcFields("Table Name");
            end;
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None";
        }
        field(3; "PDF Report ID"; Integer)
        {
            Caption = 'PDF Report ID';
            NotBlank = true;
            TableRelation = AllObj."Object ID" where("Object Type" = const(Report));

            trigger OnValidate()
            begin
                CalcFields("Report Name");
            end;
        }
        field(4; "Table Name"; Text[249])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Table),
                                                                           "Object ID" = field("Table ID")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Report Name"; Text[249])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Report),
                                                                           "Object ID" = field("PDF Report ID")));
            Caption = 'Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Table ID", "Document Type")
        {
            Clustered = true;
        }
    }
}