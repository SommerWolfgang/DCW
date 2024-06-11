table 6086405 "CEM Field Type Dependency"
{
    Caption = 'Field Type Dependency';

    fields
    {
        field(10; "Field Type Code"; Code[20])
        {
            Caption = 'Field Type Code';
            TableRelation = "CEM Field Type";

        }
        field(11; Condition; Option)
        {
            Caption = 'Condition';
            InitValue = "Has any value";
            OptionCaption = 'Has a specific value,Has any value';
            OptionMembers = "Has a specific value","Has any value";

            trigger OnValidate()
            begin
                if Condition = Condition::"Has any value" then
                    Value := '';

                if Condition = Condition::"Has a specific value" then
                    SpecificValuesAllowedCheck("Field Type Code");
            end;
        }
        field(12; Value; Code[50])
        {
            Caption = 'Value';
            TableRelation = "CEM Lookup Value".Code where("Field Type Code" = field("Field Type Code"));

            trigger OnValidate()
            begin
                if Condition = Condition::"Has any value" then
                    Value := '';
            end;
        }
        field(20; "Reference Field Type Code"; Code[20])
        {
            Caption = 'Reference Field Type Code';
        }
        field(21; Expectation; Option)
        {
            Caption = 'Expectation';
            OptionCaption = 'Must have a value,Must have a specific value,Must have no value';
            OptionMembers = "Must have a value","Must have a specific value","Must have no value";

            trigger OnValidate()
            begin
                SystemDependencyCheck(Rec);

                if (Expectation in [Expectation::"Must have no value", Expectation::"Must have a value"]) then
                    "Expected Value" := '';

                if Expectation = Expectation::"Must have a specific value" then
                    SpecificValuesAllowedCheck("Reference Field Type Code");
            end;
        }
        field(22; "Expected Value"; Code[50])
        {
            Caption = 'Expected Value';
            TableRelation = "CEM Lookup Value".Code where("Field Type Code" = field("Reference Field Type Code"));

            trigger OnValidate()
            begin
                SystemDependencyCheck(Rec);

                if (Expectation in [Expectation::"Must have no value", Expectation::"Must have a value"]) then
                    "Expected Value" := '';
            end;
        }
        field(30; "System Created Dependency"; Boolean)
        {
            BlankZero = true;
            Caption = 'System Created';
            Editable = false;
        }
        field(31; Disabled; Boolean)
        {
            Caption = 'Disabled';
            Editable = false;
        }
        field(32; "Detected Conflicts"; Text[250])
        {
            Caption = 'Detected Conflicts';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Field Type Code", Condition, Value, "Reference Field Type Code")
        {
            Clustered = true;
        }
    }
    procedure SetupConsistencyCheck(var SuccessStatus: Boolean; var ErrorCollector: Text[1024])
    begin
        SuccessStatus := false;
        ErrorCollector := '';
    end;

    procedure SystemDependencyCheck(FieldTypeDependency: Record "CEM Field Type Dependency")
    begin
    end;

    procedure DisabledDependenciesExist(var DetectedConflictMessage: Text[1024]): Boolean
    begin
        DetectedConflictMessage := '';
    end;

    procedure FieldDependencyFirstCheck(var FieldTypeDependency: Record "CEM Field Type Dependency")
    begin
    end;

    procedure FieldDependencySecondCheck(var FieldTypeDependency: Record "CEM Field Type Dependency")
    begin
    end;

    procedure MissingInformationCheck(FieldTypeDependency: Record "CEM Field Type Dependency")
    begin
        FieldTypeDependency.TestField("Field Type Code");
        FieldTypeDependency.TestField("Reference Field Type Code");

        if FieldTypeDependency.Condition = Condition::"Has a specific value" then
            FieldTypeDependency.TestField(Value);

        if FieldTypeDependency.Expectation = Expectation::"Must have a specific value" then
            FieldTypeDependency.TestField("Expected Value");
    end;


    procedure DataTypeCheck(var FieldTypeDependency: Record "CEM Field Type Dependency")
    begin
    end;

    procedure AllowedDataType(DataType: Option "Integer",Text,"Code",Decimal,Option,Boolean,Date,Address,Attendees,DateTime): Boolean
    begin
    end;

    procedure LookupDataType(DataType: Option "Integer",Text,"Code",Decimal,Option,Boolean,Date,Address,Attendees,DateTime): Boolean
    begin
    end;

    procedure SpecificValuesAllowedCheck(FieldTypeCode: Code[20])
    begin
    end;

    procedure ConfiguredFieldTypeCheck(var FieldTypeDependency: Record "CEM Field Type Dependency")
    begin
    end;

    procedure FieldTypeMandatoryCheck(var FieldTypeDependency: Record "CEM Field Type Dependency")
    begin
    end;

    procedure LookupValueAccessCheck(var FieldTypeDependency: Record "CEM Field Type Dependency")
    begin
    end;

    procedure RestrictedAccessDetected(FieldTypeCode: Code[20]; ExpectedValue: Code[50]; UserType: Option User,Group; UserCode: Code[50]): Boolean
    begin
    end;

    procedure ConflictingAndCircularCheck(RunSilent: Boolean) SuccessStatus: Boolean
    begin
    end;

    procedure SetupFieldDependencies()
    begin
    end;

    procedure UpdateSystemDependencies()
    begin
    end;

    procedure FieldDependencyConfigured(FieldTypeCode: Code[20]; RefFieldTypeCode: Code[20]): Boolean
    begin
    end;

    procedure MutuallyExclusiveDependencies(Dependency1: Record "CEM Field Type Dependency"; Dependency2: Record "CEM Field Type Dependency") MutuallyExclusive: Boolean
    begin
    end;

    procedure IdenticalDependencies(Dependency1: Record "CEM Field Type Dependency"; Dependency2: Record "CEM Field Type Dependency"): Boolean
    begin
    end;

    procedure OnSameDocumentType(Dependency1: Record "CEM Field Type Dependency"; Dependency2: Record "CEM Field Type Dependency"): Boolean
    begin
    end;

    procedure DependencyIsUsed(Dependency: Record "CEM Field Type Dependency"): Boolean
    begin
    end;

    procedure IsExpenseDependency(Dependency: Record "CEM Field Type Dependency"): Boolean
    begin
    end;

    procedure IsMileageDependency(Dependency: Record "CEM Field Type Dependency"): Boolean
    begin
    end;

    procedure IsPerDiemDependency(Dependency: Record "CEM Field Type Dependency"): Boolean
    var
        ConfiguredFieldType: Record "CEM Configured Field Type";
    begin
        ConfiguredFieldType.SetRange(Type, ConfiguredFieldType.Type::"Per Diem");
        ConfiguredFieldType.SetRange("Sub Type", ConfiguredFieldType."Sub Type"::" ");
        ConfiguredFieldType.SetFilter("Field Code", '%1|%2', Dependency."Field Type Code", Dependency."Reference Field Type Code");
        exit(ConfiguredFieldType.Count = 2);
    end;


    procedure IsSettlementDependency(Dependency: Record "CEM Field Type Dependency"): Boolean
    var
        ConfiguredFieldType: Record "CEM Configured Field Type";
    begin
        ConfiguredFieldType.SetRange(Type, ConfiguredFieldType.Type::Settlement);
        ConfiguredFieldType.SetRange("Sub Type", ConfiguredFieldType."Sub Type"::" ");
        ConfiguredFieldType.SetFilter("Field Code", '%1|%2', Dependency."Field Type Code", Dependency."Reference Field Type Code");
        exit(ConfiguredFieldType.Count = 2);
    end;


    procedure DeleteDependenciesNotNeeded(DocumentType: Option Expense,Mileage,Settlement,"Per Diem"; FieldTypeCode: Code[20])
    begin
    end;

    procedure IterativelyBuildConflictingSet(var DependencyBeingChecked: Record "CEM Field Type Dependency")
    begin
    end;

    procedure IterativelyBuildDependencySet(var DependencyBeingChecked: Record "CEM Field Type Dependency")
    begin
    end;

    procedure LookupFieldTypeLookupValue(var Text: Text[1024]): Boolean
    begin
        Text := '';
    end;
}