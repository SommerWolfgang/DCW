table 6086344 "CEM Credit Card User Mapping"
{
    Caption = 'Credit Card User Mapping';
    DataCaptionFields = "Card No.", "Continia User ID";

    fields
    {
        field(2; "Card No."; Code[20])
        {
            Caption = 'Card No.';
            TableRelation = "CEM Continia User Credit Card"."Card No." WHERE("Continia User ID" = FIELD("Continia User ID"));
        }
        field(3; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
            TableRelation = "CDC Continia User Setup";
        }
        field(4; "Field No."; Integer)
        {
            Caption = 'Field No.';
            TableRelation = "CEM Credit Card Mapping"."Field No." WHERE("Field No." = FIELD("Field No."));

            trigger OnValidate()
            var
                CreditCardMapping: Record "CEM Credit Card Mapping";
            begin
                if not CreditCardMapping.Get("Field No.") then
                    Error(CreditCardMappingFieldNotValid, "Field No.", CreditCardMapping.TableCaption);
            end;
        }
        field(5; Value; Text[250])
        {
            Caption = 'Value';
        }
        field(6; "Field Name"; Text[30])
        {
            CalcFormula = Lookup(Field.FieldName WHERE(TableNo = CONST(6086330),
                                                        "No." = FIELD("Field No.")));
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Card No.", "Continia User ID", "Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        CreditCardMappingFieldNotValid: Label 'Field %1 not valild. Should be selected from the list of fields entered in %2';
        CreditCardMappingNotConsistent: Label 'You must specify a value for the following fields: %1';


    procedure CheckForConsistency()
    var
        ContiniaUserCreditCard: Record "CEM Continia User Credit Card";
        CreditCardMapping: Record "CEM Credit Card Mapping";
        CreditCardUserMapping: Record "CEM Credit Card User Mapping";
        CardMappingFields: Integer;
        CreditCardFields: Integer;
    begin
        CardMappingFields := CreditCardMapping.Count;
        if CardMappingFields < 2 then
            exit;

        if ContiniaUserCreditCard.FindSet then
            repeat
                CreditCardUserMapping.SetRange("Card No.", ContiniaUserCreditCard."Card No.");
                CreditCardUserMapping.SetRange("Continia User ID", ContiniaUserCreditCard."Continia User ID");
                CreditCardFields := CreditCardUserMapping.Count;

                if (CreditCardFields > 0) and (CreditCardFields <> CardMappingFields) then
                    Error(CreditCardMappingNotConsistent, CreditCardMapping.GetListOfAllRequiredFields);
            until ContiniaUserCreditCard.Next = 0;
    end;
}

