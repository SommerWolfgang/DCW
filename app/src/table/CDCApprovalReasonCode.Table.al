table 6085773 "CDC Approval Reason Code"
{
    Caption = 'Approval Reason Code';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
            TableRelation = AllObj."Object ID" where("Object Type" = const(Table));
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None";
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            Description = 'OptionString contains placeholders for Approve and Forward';
            OptionCaption = ' ,Reject,,Put on Hold';
            OptionMembers = ,Reject,,"Put on Hold";
        }
        field(4; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            NotBlank = true;
            TableRelation = "Reason Code";
        }
        field(5; Description; Text[100])
        {
            CalcFormula = lookup("Reason Code".Description where(Code = field("Reason Code")));
            Caption = 'Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Table ID", "Document Type", Type, "Reason Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

