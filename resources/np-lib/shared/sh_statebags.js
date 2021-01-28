const EXT_ENTITY = 41;
const EXT_PLAYER = 42;

function NewStateBag (es) {
    const sv = IsDuplicityVersion();

    return new Proxy(
        {},
        {
            get(_, k) {
                if (k === 'set') {
                    return (s, v, r) => {
                        const payload = msgpack_pack(v);
                        SetStateBagValue(es, s, payload, payload.length, r);
                    };
                }

                return GetStateBagValue(es, k);
            },

            set(_, k, v) {
                const payload = msgpack_pack(v);
                return SetStateBagValue(es, k, payload, payload.length, sv);
            },
        },
    );
};

const GlobalState = NewStateBag('global');

const entityTM = {
    get(t, k) {
        if (k === 'state') {
            const es = `entity:${NetworkGetNetworkIdFromEntity(t.__data)}`;

            if (IsDuplicityVersion()) {
                EnsureEntityStateBag(t.__data);
            }

            return NewStateBag(es);
        }

        return null;
    },

    set() {
        throw new Error('Not allowed at this time.');
    },

    __ext: EXT_ENTITY,

    __pack: () => {
        return String(NetworkGetNetworkIdFromEntity(this.__data));
    },

    __unpack: (data, t) => {
        const ref = NetworkGetEntityFromNetworkId(Number(data));
        return new Proxy({ __data: ref }, entityTM);
    },
};

const playerTM = {
    get(t, k) {
        if (k === 'state') {
            const pid = t.__data;

            if (pid === -1) {
                pid = GetPlayerServerId(PlayerId());
            }

            const es = `player:${pid}`;

            return NewStateBag(es);
        }

        return null;
    },

    set() {
        throw new Error('Not allowed at this time.');
    },

    __ext: EXT_PLAYER,

    __pack: () => {
        return String(this.__data);
    },

    __unpack: (data, t) => {
        const ref = Number(data);
        return new Proxy({ __data: ref }, playerTM);
    },
};

function Entity(ent) {
    if (typeof ent === 'number') {
        return new Proxy({ __data: ent }, entityTM);
    }

    return ent;
};

function Player(ent) {
    if (typeof ent === 'number' || typeof ent === 'string') {
        return new Proxy({ __data: Number(ent) }, playerTM);
    }

    return ent;
};
