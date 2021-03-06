
class QgsVectorDataProvider : QgsDataProvider
{
%TypeHeaderCode
#include <qgsvectordataprovider.h>
%End

  public:

    // If you add to this, please also add to capabilitiesString()
    /**
     * enumeration with capabilities that providers might implement
     */
    enum Capability
    {
      /** Provider has no capabilities */
      NoCapabilities,
      /** Allows adding features */
      AddFeatures,
      /** Allows deletion of features */
      DeleteFeatures,
      /** Allows modification of attribute values */
      ChangeAttributeValues,
      /** Allows addition of new attributes (fields) */
      AddAttributes,
      /** Allows deletion of attributes (fields) */
      DeleteAttributes,
      /** Allows creation of spatial index */
      CreateSpatialIndex,
      /** Fast access to features using their ID */
      SelectAtId,
      /** Allows modifications of geometries */
      ChangeGeometries,
      /** Can create indexes on provider's fields */
      CreateAttributeIndex,
      /** Allows user to select encoding */
      SelectEncoding,
      /** Supports simplification of geometries on provider side according to a distance tolerance */
      SimplifyGeometries,
      /** Supports topological simplification of geometries on provider side according to a distance tolerance */
      SimplifyGeometriesWithTopologicalValidation,
      /** Supports transactions*/
      TransactionSupport,
      /** Supports circular geometry types (circularstring, compoundcurve, curvepolygon)*/
      CircularGeometries,
      /** Supports joint updates for attributes and geometry
       * Providers supporting this should still define ChangeGeometries | ChangeAttributeValues
       */
      ChangeFeatures,
      /** Supports renaming attributes (fields). Added in QGIS 2.16 */
      RenameAttributes,
      //! Supports fast truncation of the layer (removing all features). Added in QGIS 3.0
      FastTruncate,
    };
    typedef QFlags<QgsVectorDataProvider::Capability> Capabilities;

    /** Bitmask of all provider's editing capabilities */
    static const int EditingCapabilities;

    /**
     * Enumeration of feature count states
     */
    enum FeatureCountState
    {
      //! Feature count not yet computed
      Uncounted = -2,
      //! Provider returned an unknown feature count
      UnknownCount = -1,
    };

    /**
     * Constructor of the vector provider
     * @param uri  uniform resource locator (URI) for a dataset
     */
    QgsVectorDataProvider( const QString& uri = QString() );

    /**
     * Destructor
     */
    virtual ~QgsVectorDataProvider();

    /**
     * Return feature source object that can be used for querying provider's data. The returned feature source
     * is independent from provider - any changes to provider's state (e.g. change of subset string) will not be
     * reflected in the feature source, therefore it can be safely used for processing in background without
     * having to care about possible changes within provider that may happen concurrently. Also, even in the case
     * of provider being deleted, any feature source obtained from the provider will be kept alive and working
     * (they are independent and owned by the caller).
     *
     * Sometimes there are cases when some data needs to be shared between vector data provider and its feature source.
     * In such cases, the implementation must ensure that the data is not susceptible to run condition. For example,
     * if it is possible that both feature source and provider may need reading/writing to some shared data at the
     * same time, some synchronization mechanisms must be used (e.g. mutexes) to prevent data corruption.
     *
     * @note added in 2.4
     * @return new instance of QgsAbstractFeatureSource (caller is responsible for deleting it)
     */
    virtual QgsAbstractFeatureSource *featureSource() const = 0 /Factory/;

    /**
     * Returns the permanent storage type for this layer as a friendly name.
     */
    virtual QString storageType() const;

    /**
     * Query the provider for features specified in request.
     * @param request feature request describing parameters of features to return
     * @returns iterator for matching features from provider
     */
    virtual QgsFeatureIterator getFeatures( const QgsFeatureRequest& request = QgsFeatureRequest() ) const = 0;

    /**
     * Returns the geometry type which is returned by this layer
     */
    virtual QgsWkbTypes::Type wkbType() const = 0;

    /**
     * Number of features in the layer
     * @return long containing number of features
     */
    virtual long featureCount() const = 0;

    /**
     * Returns the fields associated with this data provider.
     */
    virtual QgsFields fields() const = 0;

    /**
     * Return a short comment for the data that this provider is
     * providing access to (e.g. the comment for postgres table).
     */
    virtual QString dataComment() const;

    /**
     * Returns the minimum value of an attribute
     * @param index the index of the attribute
     *
     * Default implementation walks all numeric attributes and caches minimal
     * and maximal values. If provider has facilities to retrieve minimal
     * value directly, override this function.
     */
    virtual QVariant minimumValue( int index ) const;

    /**
     * Returns the maximum value of an attribute
     * @param index the index of the attribute
     *
     * Default implementation walks all numeric attributes and caches minimal
     * and maximal values. If provider has facilities to retrieve maximal
     * value directly, override this function.
     */
    virtual QVariant maximumValue( int index ) const;

    /**
     * Return unique values of an attribute
     * @param index the index of the attribute
     * @param uniqueValues values reference to the list to fill
     * @param limit maxmum number of the values to return
     *
     * Default implementation simply iterates the features
     */
    virtual void uniqueValues( int index, QList<QVariant> &uniqueValues /Out/, int limit = -1 ) const;

    /**
     * Returns unique string values of an attribute which contain a specified subset string. Subset
     * matching is done in a case-insensitive manner.
     * @param index the index of the attribute
     * @param substring substring to match (case insensitive)
     * @param limit maxmum number of the values to return, or -1 to return all unique values
     * @param feedback optional feedback object for canceling request
     * @returns list of unique strings containing substring
     */
    virtual QStringList uniqueStringsMatching( int index, const QString& substring, int limit = -1,
                                               QgsFeedback* feedback = nullptr ) const;

    /** Calculates an aggregated value from the layer's features. The base implementation does nothing,
     * but subclasses can override this method to handoff calculation of aggregates to the provider.
     * @param aggregate aggregate to calculate
     * @param index the index of the attribute to calculate aggregate over
     * @param parameters parameters controlling aggregate calculation
     * @param context expression context for filter
     * @param ok will be set to true if calculation was successfully performed by the data provider
     * @return calculated aggregate value
     * @note added in QGIS 2.16
     */
    virtual QVariant aggregate( QgsAggregateCalculator::Aggregate aggregate,
                                int index,
                                const QgsAggregateCalculator::AggregateParameters& parameters,
                                QgsExpressionContext* context,
                                bool& ok ) const;

    /**
     * Returns the possible enum values of an attribute. Returns an empty stringlist if a provider does not support enum types
     * or if the given attribute is not an enum type.
     * @param index the index of the attribute
     * @param enumList reference to the list to fill
     */
    virtual void enumValues( int index, QStringList& enumList /Out/ ) const;

    /**
     * Adds a list of features
     * @return true in case of success and false in case of failure
     */
    virtual bool addFeatures( QList<QgsFeature> &flist /In,Out/ );

    /**
     * Deletes one or more features from the provider. This requires the DeleteFeatures capability.
     * @param id list containing feature ids to delete
     * @return true in case of success and false in case of failure
     * @see truncate()
     */
    virtual bool deleteFeatures( const QgsFeatureIds &id );

    /**
     * Removes all features from the layer. This requires either the FastTruncate or DeleteFeatures capability.
     * Providers with the FastTruncate capability will use an optimised method to truncate the layer.
     * @returns true in case of success and false in case of failure.
     * @note added in QGIS 3.0
     * @see deleteFeatures()
     */
    virtual bool truncate();

    /**
     * Adds new attributes
     * @param attributes list of new attributes
     * @return true in case of success and false in case of failure
     */
    virtual bool addAttributes( const QList<QgsField> &attributes );

    /**
     * Deletes existing attributes
     * @param attributes a set containing indices of attributes
     * @return true in case of success and false in case of failure
     */
    virtual bool deleteAttributes( const QSet<int> &attributes );

    /**
     * Renames existing attributes.
     * @param renamedAttributes map of attribute index to new attribute name
     * @return true in case of success and false in case of failure
     * @note added in QGIS 2.16
     */
    virtual bool renameAttributes( const QgsFieldNameMap& renamedAttributes );

    /**
     * Changes attribute values of existing features.
     * @param attr_map a map containing changed attributes
     * @return true in case of success and false in case of failure
     */
    virtual bool changeAttributeValues( const QMap<qint64, QMap<int, QVariant> > &attr_map );

    /**
     * Changes attribute values and geometries of existing features.
     * @param attr_map a map containing changed attributes
     * @param geometry_map   A QgsGeometryMap whose index contains the feature IDs
     *                       that will have their geometries changed.
     *                       The second map parameter being the new geometries themselves
     * @return true in case of success and false in case of failure
     */
    virtual bool changeFeatures( const QMap<qint64, QMap<int, QVariant> > &attr_map,
                                 const QMap<qint64, QgsGeometry> &geometry_map );

    /**
     * Returns any literal default values which are present at the provider for a specified
     * field index. Important - this should ONLY be called when creating an attribute to insert
     * directly into the database. Do not call this method for non-feature creation or modification,
     * e.g., when validating an attribute or to compare it against an existing value, as calling it
     * can cause changes to the underlying data source (e.g., Postgres provider where the default value
     * is calculated as a result of a sequence). It is recommended that you instead use the methods
     * in QgsVectorLayerUtils such as QgsVectorLayerUtils::createFeature()
     * so that default value handling and validation is automatically carried out.
     * @see defaultValueClause()
     */
    virtual QVariant defaultValue( int fieldIndex ) const;

    /**
     * Returns any default value clauses which are present at the provider for a specified
     * field index. These clauses are usually SQL fragments which must be evaluated by the
     * provider, e.g., sequence values.
     * @see defaultValue()
     * @note added in QGIS 3.0
     */
    virtual QString defaultValueClause( int fieldIndex ) const;

    /**
     * Returns any constraints which are present at the provider for a specified
     * field index.
     * @note added in QGIS 3.0
     * @see skipConstraintCheck()
     */
    QgsFieldConstraints::Constraints fieldConstraints( int fieldIndex ) const;

    /**
     * Returns true if a constraint check should be skipped for a specified field (e.g., if
     * the value returned by defaultValue() is trusted implicitly. An optional attribute value can be
     * passed which can help refine the skip constraint check.
     * @note added in QGIS 3.0
     * @see fieldConstraints()
     */
    virtual bool skipConstraintCheck( int fieldIndex, QgsFieldConstraints::Constraint constraint, const QVariant& value = QVariant() ) const;

    /**
     * Changes geometries of existing features
     * @param geometry_map   A QgsGeometryMap whose index contains the feature IDs
     *                       that will have their geometries changed.
     *                       The second map parameter being the new geometries themselves
     * @return               True in case of success and false in case of failure
     */
    virtual bool changeGeometryValues( const QMap<qint64, QgsGeometry> &geometry_map );

    /**
     * Creates a spatial index on the datasource (if supported by the provider type).
     * @return true in case of success
     */
    virtual bool createSpatialIndex();

    /** Create an attribute index on the datasource*/
    virtual bool createAttributeIndex( int field );

    /** Returns a bitmask containing the supported capabilities
        @note, some capabilities may change depending on whether
        a spatial filter is active on this provider, so it may
        be prudent to check this value per intended operation.
     */
    virtual Capabilities capabilities() const;

    /**
     *  Returns the above in friendly format.
     */
    QString capabilitiesString() const;

    /**
     * Set encoding used for accessing data from layer
     */
    virtual void setEncoding( const QString& e );

    /**
     * Get encoding which is used for accessing data
     */
    QString encoding() const;

    /**
     * Returns the index of a field name or -1 if the field does not exist
     */
    int fieldNameIndex( const QString& fieldName ) const;

    /**
     * Return a map where the key is the name of the field and the value is its index
     */
    QMap<QString, int> fieldNameMap() const;

    /**
     * Return list of indexes to fetch all attributes in nextFeature()
     */
    virtual QList<int> attributeIndexes() const;

    /**
     * Return list of indexes of fields that make up the primary key
     */
    virtual QList<int> pkAttributeIndexes() const;

    /**
     * Return list of indexes to names for QgsPalLabeling fix
     */
    virtual QHash<int, QString> palAttributeIndexNames() const;

    /**
     * check if provider supports type of field
     */
    bool supportedType( const QgsField &field ) const;

    struct NativeType
    {
      NativeType( const QString& typeDesc, const QString& typeName, QVariant::Type type, int minLen = 0, int maxLen = 0, int minPrec = 0, int maxPrec = 0, QVariant::Type subType = QVariant::Invalid );

      QString mTypeDesc;
      QString mTypeName;
      QVariant::Type mType;
      int mMinLen;
      int mMaxLen;
      int mMinPrec;
      int mMaxPrec;
      QVariant::Type mSubType;
    };

    /**
     * Returns the names of the supported types
     */
    QList< QgsVectorDataProvider::NativeType > nativeTypes() const;

    /**
     * Returns true if the provider is strict about the type of inserted features
     * (e.g. no multipolygon in a polygon layer)
     */
    virtual bool doesStrictFeatureTypeCheck() const;

    /** Returns a list of available encodings */
    static QStringList availableEncodings();

    /**
     * Provider has errors to report
     */
    bool hasErrors() const;

    /**
     * Clear recorded errors
     */
    void clearErrors();

    /**
     * Get recorded errors
     */
    QStringList errors() const;

    /**
     * It returns false by default.
     * Must be implemented by providers that support saving and loading styles to db returning true
     */
    virtual bool isSaveAndLoadStyleToDatabaseSupported() const;

    /**
     * Checks if the provider supports style removal
     * Must be implemented by providers that support delete styles from db returning true
     * @note added in QGIS 3.0
     * @return true if delete operation is supported by the provider
     */
    virtual bool isDeleteStyleFromDatabaseSupported() const;

    static QVariant convertValue( QVariant::Type type, const QString& value );

    /**
     * Returns the transaction this data provider is included in, if any.
     */
    virtual QgsTransaction* transaction() const;

    /**
     * Forces a reload of the underlying datasource if the provider implements this
     * method.
     * In particular on the OGR provider, a pooled connection will be invalidated.
     * This forces QGIS to reopen a file or connection.
     * This can be required if the underlying file is replaced.
     */
    virtual void forceReload();

    /**
     * Get the list of layer ids on which this layer depends. This in particular determines the order of layer loading.
     */
    virtual QSet<QgsMapLayerDependency> dependencies() const;

    /**
     * Discover the available relations with the given layers.
     * @param self the layer using this data provider.
     * @param layers the other layers.
     * @return the list of N-1 relations from this provider.
     * @note added in QGIS 3.0
     */
    virtual QList<QgsRelation> discoverRelations( const QgsVectorLayer* self, const QList<QgsVectorLayer*>& layers ) const;

    /**
     * Get some metadata that will be display in the metadata tab of the layer properties.
     * @return The provider metadata
     */
    virtual QVariantMap metadata() const;

    /**
     * Get the translated metadata key.
     * @param mdKey The metadata key
     * @return The translated metadata value
     */
    virtual QString translateMetadataKey( const QString& mdKey ) const;

    /**
     * Get the translated metadata value.
     * @param mdKey The metadata key
     * @param value The metadata value
     * @return The translated metadata value
     */
    virtual QString translateMetadataValue( const QString& mdKey, const QVariant& value ) const;

  signals:
    /**
     * Signals an error in this provider
     *
     * @note Added const in QGIS 3.0
     */
    void raiseError( const QString& msg ) const;

  protected:
    /**
     * Invalidates the min/max cache. This will force the provider to recalculate the
     * cache the next time it is requested.
     */
    void clearMinMaxCache();

    /**
     * Populates the cache of minimum and maximum attribute values.
     */
    void fillMinMaxCache() const;

    /**
     * Push a notification about errors that happened in this providers scope.
     * Errors should be translated strings that require the users immediate
     * attention.
     *
     * For general debug information use QgsMessageLog::logMessage() instead.
     *
     * @note Added in QGIS 3.0
     */
    void pushError( const QString& msg ) const;

    /**
     * Converts the geometry to the provider type if possible / necessary
     * @return the converted geometry or nullptr if no conversion was necessary or possible
     */
    QgsGeometry* convertToProviderType( const QgsGeometry& geom ) const /Factory/;

    /**
     * Set the list of native types supported by this provider.
     * Usually done in the constructor.
     *
     * @note Added in QGIS 3.0
     */
    void setNativeTypes(const QList<QgsVectorDataProvider::NativeType>& nativeTypes);

    /**
     * Get this providers encoding
     *
     * @note Added in QGIS 3.0
     */
    QTextCodec* textEncoding() const;

};

QFlags<QgsVectorDataProvider::Capability> operator|(QgsVectorDataProvider::Capability f1, QFlags<QgsVectorDataProvider::Capability> f2);
