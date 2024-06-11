table 6085702 "CDC Purchase Line Relationship"
{
    Caption = 'Purchase Line Relationship';

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            Description = 'Invoice,Cr.Memo';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FIELD("Document Type"));
        }
        field(3; "Document Line No."; Integer)
        {
            Caption = 'Line No.';
            TableRelation = "Purchase Line"."Line No." WHERE("Document Type" = FIELD("Document Type"),
                                                              "Document No." = FIELD("Document No."));
        }
        field(4; "Related Document Type"; Option)
        {
            Caption = 'Document Type';
            Description = 'Order,Ret.Order';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(5; "Related Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FIELD("Related Document Type"));
        }
        field(6; "Related Line No."; Integer)
        {
            Caption = 'Related Line No.';
            TableRelation = "Purchase Line"."Line No." WHERE("Document Type" = FIELD("Related Document Type"),
                                                              "Document No." = FIELD("Related Document No."));
        }
        field(7; "Suppress Matched Error"; Boolean)
        {
            Caption = 'Suppress Matched Error';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Document Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Related Document Type", "Related Document No.", "Related Line No.")
        {
        }
        key(Key3; "Document Type", "Document No.", "Related Document Type", "Related Document No.", "Related Line No.")
        {
        }
    }

    fieldgroups
    {
    }


    procedure GetQuantity(): Decimal
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.Get("Document Type", "Document No.", "Document Line No.");
        exit(PurchLine."Outstanding Quantity");
    end;
}

